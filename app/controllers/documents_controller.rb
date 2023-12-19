
class DocumentsController < ApplicationController
  before_action :set_document, only: %i[destroy show generate_pdf download send_email generate_history download_hist send_email_hist]

  # GET /documents
  def index
    @documents = Document.all
    render json: @documents
  end

  # GET /documents/1
  def show
    @document = Document.find(params[:id])
    render json: @document
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Documento não encontrado" }, status: :not_found
  end

  # POST /documents
    def create
      @document = Document.new(document_params)
      
      if @document.save
        if @document.tipo == 'declaracao'
          Rails.logger.info "Documento Declaração criado com sucesso: #{@document}"
          PdfDownloadWorker.send_to_queue(@document)
          pdf_url = generate_pdf(@document)
          render json: { status: 'Documento criado com sucesso', document: @document, pdf_url: pdf_url }, status: :created
        elsif @document.tipo == 'historico'
          grade_ids = params[:grade_ids] || []
          @document.grades << Grade.where(id: grade_ids)
          Rails.logger.info "Documento Histórico criado com sucesso: #{@document}"
          PdfDownloadWorker.send_to_queue(@document)
          pdf_hist_url = generate_history(@document, @document.grades)
          render json: { status: 'Documento criado com sucesso', document: @document, grade_ids: grade_ids, pdf_url: pdf_hist_url }, status: :created
        end
      else
        Rails.logger.error "Erro ao criar documento: #{@document.errors}"
        render json: @document.errors, status: :unprocessable_entity
      end
    end

  # DELETE /documents/1
  def destroy
    @document.destroy
  end

  def generate_pdf(document)
    pdf_dec = DeclarationPdfService.generate(document)
    pdf_url = "/pdfs/documento_#{document.id}.pdf"
    pdf_dec.render_file Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf")
    pdf_url
  end

  def generate_history(document, grades)
    pdf_hist = HistoryPdfService.generate(document, grades)
    pdf_hist_url = "/pdfs/historico_#{document.id}.pdf"
    
    pdf_hist.render_file Rails.root.join('public', 'pdfs', "historico_#{document.id}.pdf")
    pdf_hist_url
  end

  def send_email
    DocumentMailer.send_document(@document).deliver_now
    render json: { message: "E-mail com o documento enviado com sucesso." }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
  end

  def send_email_hist
    DocumentMailer.send_document_hist(@document).deliver_now
    render json: { message: "E-mail com o documento enviado com sucesso." }, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
  end

  def download_hist
    send_file document_hist_pdf_path(@document), type: 'application/pdf', disposition: 'attachment'
  end

  def document_hist_pdf_path(document)
    Rails.root.join('public', 'pdfs', "historico_#{document.id}.pdf")
  end

  def download
    send_file document_pdf_path(@document), type: 'application/pdf', disposition: 'attachment'
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
