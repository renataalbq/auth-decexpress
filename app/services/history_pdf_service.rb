class HistoryPdfService
  def self.generate(document, grades)
    Prawn::Document.new do |pdf|
      # Configurações iniciais, como adicionar a imagem e o título
      pdf.image "#{Rails.root}/app/assets/logo2.png", width: 50, height: 50
      pdf.text "DECEXPRESS", align: :center
      pdf.move_down 20
      pdf.text "Histórico Escolar", style: :bold, align: :center
      pdf.move_down 20

      # Informações do aluno
      pdf.text "Nome do Aluno(a): #{document.nome_aluno}", align: :left
      pdf.text "Matrícula: #{document.matricula}", align: :left
      pdf.text "CPF: #{document.cpf}", align: :left
      pdf.text "Email: #{document.email_aluno}", align: :left
      pdf.move_down 20

      disciplinas = grades.map { |grade| grade[:disciplina] }.uniq
      bimestres = grades.map { |grade| grade[:bimestre] }.uniq.sort
      notas_por_disciplina = disciplinas.map do |disciplina|
        notas = bimestres.map do |bimestre|
          nota = grades.find { |g| g[:disciplina] == disciplina && g[:bimestre] == bimestre }
          nota ? nota[:nota] : "-"
        end
        [disciplina].concat(notas)
      end

      # Cabeçalho da tabela
      headers = ["Disciplina"].concat(bimestres.map { |b| "#{b}º" })
      data = notas_por_disciplina.unshift(headers)

      # Criando a tabela no PDF
      pdf.table(data, header: true, cell_style: { inline_format: true }) do
        row(0).font_style = :bold
        row(0).background_color = "EEEEEE"
        columns(1..-1).align = :center #
      end

      pdf.move_down 20

      # Texto de certificação e data
      pdf.text "Certificamos que #{document.nome_aluno}, concluiu o 2º ano do ensino médio, no ano de #{Time.zone.now.year}, de acordo com a Lei Vigente, tendo obtido os resultados constantes neste Histórico Escolar, dando-lhe o direito de prosseguimento de estudos no Ensino Médio.", align: :center, size: 10
      pdf.move_down 30
      pdf.text "João Pessoa - PB, #{Time.zone.now.strftime('%d/%m/%Y')}", align: :right, size: 12

      # Assinatura
      pdf.stroke do
        pdf.horizontal_line(0, 200)
      end
      pdf.move_down 25
      pdf.text "Coordenador(a)", align: :left, size: 12
    end
  end
end
