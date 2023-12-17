class DeclarationPdfService
    extend DataFormatHelper

    def self.generate(document)
        data_solicitacao_format = formatar_data(document.data_solicitacao)
        data_validade_format = formatar_data(document.data_validade)
        Prawn::Document.new do |pdf|
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
        end
    end
  end
  