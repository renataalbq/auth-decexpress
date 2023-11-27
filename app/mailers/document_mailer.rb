class DocumentMailer < ApplicationMailer
    default from: 'dec-express@gmx.com'
  
    def send_document(document)
      @document = document
      attachments["documento_#{document.id}.pdf"] = File.read(Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf"))
      mail(to: @document.email_aluno, subject: 'DecExpress - Declaracao Academica') do |format|
        format.text { render plain: "Aqui esta o seu documento solicitado." }
      end
    end

    def send_document_hist(document)
      @document = document
      attachments["historico_#{document.id}.pdf"] = File.read(Rails.root.join('public', 'pdfs', "historico_#{document.id}.pdf"))
      mail(to: @document.email_aluno, subject: 'DecExpress - Historico Academico') do |format|
        format.text { render plain: "Aqui esta o seu documento solicitado." }
      end
    end
end