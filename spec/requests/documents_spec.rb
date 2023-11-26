require 'rails_helper'

RSpec.describe "/documents", type: :request do
  let(:valid_attributes) {
    {
      data_solicitacao: Date.today,
      data_validade: Date.today + 1.year,
      tipo: "declaracao",
      matricula: "12345",
      cpf: "123.456.789-00",
      nome_aluno: "Aluno Teste",
      email_aluno: "aluno@teste.com"
    }
  }

  let(:valid_declaration_attributes) do
    {
      data_solicitacao: Date.today,
      data_validade: Date.today + 1.year,
      tipo: "declaracao",
      matricula: "12345",
      cpf: "123.456.789-00",
      nome_aluno: "Aluno Teste",
      email_aluno: "aluno@teste.com"
    }
  end

  let(:valid_history_attributes) do
    {
      data_solicitacao: Date.today,
      data_validade: Date.today + 1.year,
      tipo: "historico",
      matricula: "12345",
      cpf: "123.456.789-00",
      nome_aluno: "Aluno Teste",
      email_aluno: "aluno@teste.com"
    }
  end

  let(:invalid_attributes) {
    {
      data_solicitacao: nil,
      data_validade: nil,
      tipo: nil,
      matricula: nil,
      cpf: nil,
      nome_aluno: nil,
      email_aluno: nil
    }
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      Document.create! valid_attributes
      get documents_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(response.content_type).to match(a_string_including("application/json"))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      document = Document.create! valid_attributes
      get document_url(document), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Document of type 'declaracao' and generates a declaration PDF" do
        expect {
          post documents_url, params: { document: valid_declaration_attributes }, as: :json
        }.to change(Document, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["document"]["tipo"]).to eq('declaracao')
        expect(JSON.parse(response.body)["pdf_url"]).to be_present
      end

      it "creates a new Document of type 'historico' and generates a history PDF" do
        expect {
          post documents_url, params: { document: valid_history_attributes }, as: :json
        }.to change(Document, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(JSON.parse(response.body)["document"]["tipo"]).to eq('historico')
        expect(JSON.parse(response.body)["pdf_url"]).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not create a new Document" do
        expect {
          post documents_url, params: { document: invalid_attributes }, as: :json
        }.to change(Document, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe 'GET /documents/:id/generate_pdf' do
  let(:document) { create(:document, tipo: 'declaracao') } 

  it 'responds successfully' do
    document = create(:document, tipo: 'declaracao')
    get "/documents/#{document.id}/generate_pdf"
    expect(response).to be_successful
  end
end

describe 'GET #generate_pdf' do
  context 'when PDF generation fails' do
    it 'responds with an error' do
      allow(Prawn::Document).to receive(:new).and_raise(StandardError)
      get :generate_pdf, params: { id: document.id }
      expect(response).to have_http_status(:internal_server_error)
    end
  end
end

describe 'GET #download_hist' do
  it 'downloads the history PDF' do
    document = create(:document, tipo: 'historico')
    get :download_hist, params: { id: document.id }
    expect(response).to have_http_status(:ok)
    expect(response.header['Content-Type']).to include 'application/pdf'
  end
end

  describe 'GET #generate_history' do
    let(:document) { create(:document, tipo: 'historico') } # Criação de um documento de teste

    before do
      get :generate_history, params: { id: document.id }
    end

    it 'responds successfully' do
      expect(response).to be_successful
    end

    it 'generates a PDF file' do
      expect(response.header['Content-Type']).to include 'application/pdf'
    end

    it 'saves the PDF file in the correct location' do
      pdf_path = Rails.root.join('public', 'pdfs', "historico_#{document.id}.pdf")
      expect(File).to exist(pdf_path)
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested document" do
      document = Document.create! valid_attributes
      expect {
        delete document_url(document), headers: valid_headers, as: :json
      }.to change(Document, :count).by(-1)
    end
  end

  describe 'GET send_email' do
    it 'sends an email with the document' do
      get :send_email, params: { id: document.id }
      expect(response).to have_http_status(:ok)
    end

    it 'handles email sending errors' do
      allow(DocumentMailer).to receive(:send_document).and_raise(StandardError)
      
      expect do
        get :send_email, params: { id: document.id }
      end.to raise_error(StandardError)
    end
  end

  describe 'GET download' do
    it 'downloads a document' do
      get :download, params: { id: document.id }
      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to include 'application/pdf'
    end
  end

end
