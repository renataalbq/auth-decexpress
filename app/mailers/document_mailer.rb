class DocumentMailer < ApplicationMailer
    default from: 'decexpress@gmx.com'
  
    def send_document(document)
      @document = document
      attachments["documento_#{document.id}.pdf"] = File.read(Rails.root.join('public', 'pdfs', "documento_#{document.id}.pdf"))
      mail(to: @document.email_aluno, subject: 'DecExpress - Declaracao Academica') do |format|
        format.text { render plain: "Aqui esta o seu documento solicitado." }
      end
    end
end