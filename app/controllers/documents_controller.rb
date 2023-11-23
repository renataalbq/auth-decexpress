class DocumentsController < ApplicationController
  before_action :set_document, only: %i[ show destroy generate_pdf download ]

  # GET /documents
  def index
    @documents = Document.page(params[:page]).per(5) # 5 documentos por página
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
      render json: { status: 'Documento criado com sucesso', document: @document }, status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  # DELETE /documents/1
  def destroy
    @document.destroy
  end

  def generate_pdf
    pdf = Prawn::Document.new
    pdf.image "./app/assets/logo2.png", at: [0, pdf.cursor], width: 50
    pdf.bounding_box([60, pdf.cursor - 20], :width => 400, :height => 50) do
      pdf.text "DecExpress", size: 12, align: :left
    end
    pdf.move_down 50
    pdf.text "##{@document.id}", align: :center
    pdf.move_down 5
    pdf.text "DECLARAÇÃO ACADÊMICA", align: :center, style: :bold
    pdf.move_down 10
    pdf.text "Declaramos para os fins que se fizerem necessários, e por nos haver sido solicitado, que #{@document.nome_aluno}, de matrícula: #{@document.matricula} está regularmente matriculado nesta Insituição de Ensino, no ano de #{Time.now.year}.", align: :center
    pdf.move_down 10
    pdf.text "João Pessoa, #{@document.data_solicitacao}", align: :right
    pdf.text "Valido até #{@document.data_validade}", align: :right
    

    save_path = Rails.root.join('public','pdfs',"documento_#{@document.id}.pdf")
    pdf.render_file save_path.to_s
  
    send_email(@document)

    render json: { message: "PDF gerado e email enviado para #{@document.email_aluno} com sucesso." }, status: :ok
  end

  def send_email(document)
    DocumentMailer.send_document(document).deliver_now
  end

  def download
    connection = Bunny.new('amqp://guest:guest@localhost:5672')
    connection.start
  
    channel = connection.create_channel
    queue = channel.queue('documents')
  
    queue.publish(@document.id.to_s, content_type: 'text/plain')
  
    connection.close
  
    render json: { message: "E-mail com o documento está sendo enviado." }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:data_solicitacao, :data_validade, :tipo, :matricula, :cpf, :nome_aluno, :email_aluno)
    end
end
