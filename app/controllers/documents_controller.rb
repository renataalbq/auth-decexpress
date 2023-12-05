
class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show destroy generate_pdf download send_email generate_history download_hist send_email_hist]
  load_and_authorize_resource
  include DataFormatHelper

  # GET /documents
  def index
    @documents = Document.page(params[:page]).per(10) # 10 documentos por página
    render json: {
      documents: @documents,
      total_pages: @documents.total_pages,
      current_page: @documents.current_page
    }
  end

  # GET /documents/1
  def show
    render json: @document
  end

  # POST /documents
    def create
      @document = Document.new(document_params)
      
      if @document.save
        if @document.tipo == 'declaracao'
          pdf_url = generate_pdf(@document)
          render json: { status: 'Documento criado com sucesso', document: @document, pdf_url: pdf_url }, status: :created
        elsif @document.tipo == 'historico'
              @document.grades << Grade.where(id: params[:grade_ids])
          pdf_hist_url = generate_history(@document, @document.grades)
          render json: { status: 'Documento criado com sucesso', document: @document, pdf_url: pdf_hist_url }, status: :created
        end
      else
        render json: @document.errors, status: :unprocessable_entity
      end
    end

  # DELETE /documents/1
  def destroy
    @document.destroy
  end

  def generate_pdf(document)
    data_solicitacao_format = formatar_data(document.data_solicitacao)
    data_validade_format = formatar_data(document.data_validade)
    
    pdf = Prawn::Document.new
    pdf.image "./app/assets/logo2.png", at: [0, pdf.cursor], width: 50
    pdf.bounding_box([60, pdf.cursor - 20], :width => 400, :height => 50) do
      pdf.text "DecExpress", size: 14, align: :left
    end
    pdf.move_down 50
    pdf.text "##{document.id}", align: :center
    pdf.move_down 5
    pdf.text "DECLARAÇÃO ACADÊMICA", align: :center, size: 16, style: :bold
    pdf.move_down 10
    pdf.text "Declaramos para os fins que se fizerem necessários, e por nos haver sido solicitado, que #{document.nome_aluno}, de matrícula: #{document.matricula} está regularmente matriculado(a) nesta Insituição de Ensino, no ano de #{Time.now.year}.", align: :center
    pdf.move_down 20
    pdf.text "João Pessoa - PB, #{data_solicitacao_format}", align: :right, size: 12
    pdf.move_down pdf.bounds.height - pdf.cursor
    pdf.text "Valido até #{data_validade_format}", align: :right, size: 12
    Prawn::Fonts::AFM.hide_m17n_warning = true

    pdf_url = "/pdfs/documento_#{document.id}.pdf"
    pdf.render_file Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf")
    pdf_url
  end

  def generate_history(document, grades)
    pdf_hist = HistoryPdfService.generate(document, grades)
    pdf_hist_url = "/pdfs/historico_#{document.id}.pdf"
    
    pdf_hist.render_file Rails.root.join('public', 'pdfs', "historico_#{document.id}.pdf")
    pdf_hist_url
  end

  def send_email
    request_pdf_service = RequestPdfService.new
    request_pdf_service.publish("Enviando email para o documento de ID: #{@document.id}")

    DocumentMailer.send_document(@document).deliver_now
    render json: { message: "E-mail com o documento enviado com sucesso." }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    ensure
      request_pdf_service.close
  end

  def send_email_hist
    request_pdf_service = RequestPdfService.new
    request_pdf_service.publish("Enviando email para o documento de ID: #{@document.id}")
    DocumentMailer.send_document_hist(@document).deliver_now
    render json: { message: "E-mail com o documento enviado com sucesso." }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    ensure
      request_pdf_service.close
  end

  def download_hist
    request_pdf_service = RequestPdfService.new
    begin
      request_pdf_service.publish("Solicitação de download para historico de ID: #{@document.id}")
      send_file document_hist_pdf_path(@document), type: 'application/pdf', disposition: 'attachment'
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    ensure
      request_pdf_service.close
    end
  end

  def document_hist_pdf_path(document)
    Rails.root.join('public', 'pdfs', "historico_#{document.id}.pdf")
  end

  def download
    request_pdf_service = RequestPdfService.new
    begin
      request_pdf_service.publish(@document.id)
      render json: { message: 'Seu download foi enfileirado e será processado em breve.' }, status: :ok
      #send_file document_pdf_path(@document), type: 'application/pdf', disposition: 'attachment'
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    ensure
      request_pdf_service.close
    end
  end

  def document_pdf_path(document)
    Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:data_solicitacao, :data_validade, :tipo, :matricula, :cpf, :nome_aluno, :email_aluno, grade_ids: [])
    end
end
