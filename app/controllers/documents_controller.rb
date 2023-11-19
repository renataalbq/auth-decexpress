class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show update destroy ]

  # GET /documents
  def index
    @documents = Document.page(params[:page]).per(10) # 10 documentos por página
    render json: @documents
  end

  # GET /documents/1
  def show
    render json: @document
  end

  # POST /documents
  def create
    @document = Document.new(document_params)
  
    if @document.save
      DOCUMENTO_QUEUE.publish(@document.id.to_s, content_type: 'text/plain')
      render json: { status: 'Solicitação recebida e adicionada à fila', document: @document }, status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
  end

  def generate_pdf
    @document = Document.find(params[:id])
  
    pdf = Prawn::Document.new
    pdf.text "Documento ##{params[:id]}"
    pdf.text "#{@document.nome_aluno}, de matrícula: #{@document.matricula} e CPF: #{@document.cpf} está matriculado na escola Escola no ano de #{Time.now.year}."
  
    # Salvar o PDF
    save_path = Rails.root.join('public','pdfs',"documento_#{params[:id]}.pdf")
    pdf.render_file save_path.to_s
  
    render json: { message: "PDF gerado com sucesso." }, status: :ok
  end

  def download
    @document = Document.find(params[:id])
    file_path = Rails.root.join('public','pdfs',"documento_#{params[:id]}.pdf")
  
    if File.exist?(file_path)
      send_file(file_path, filename: "documento_#{params[:id]}.pdf", type: 'application/pdf', disposition: 'attachment')
    else
      render json: { error: "Arquivo não encontrado." }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:data_solicitacao, :data_validade, :tipo, :matricula, :cpf, :nome_aluno, :url, :dados)
    end
end
