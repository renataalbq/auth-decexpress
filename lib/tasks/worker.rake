namespace :worker do
    desc "Inicia o Worker de Solicitação de PDF"
    task start: :environment do
      PdfDownloadWorker.new.start
    end
  end
  