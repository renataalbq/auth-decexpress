class HistoryPdfService
    def self.generate(document)
      Prawn::Document.new do |pdf|
        pdf.image "#{Rails.root}/app/assets/logo2.png", width: 50, height: 50
        pdf.text "DECEXPRESS", align: :center
  
        pdf.move_down 20
        pdf.text "Histórico Escolar", style: :bold, align: :center
        pdf.move_down 20
        pdf.text "Nome do Aluno(a): #{document.nome_aluno}", align: :left
        pdf.text "Matrícula: #{document.matricula}", align: :left
        pdf.text "CPF: #{document.cpf}", align: :left
        pdf.text "Email: #{document.email_aluno}", align: :left
        pdf.move_down 20
  
        notas = {
            ' Língua Portuguesa' => [9, 10, 8, 7],
            ' Inglês' => [10, 10, 9, 10],
            ' Matemática' => [8, 9, 7, 6],
            ' Biologia' => [10, 9, 8, 7],
            ' Química' => [9, 8, 8, 7],
            ' Física' => [7, 7, 6, 7],
            ' História' => [9, 8, 7, 6],
            ' Geografia' => [8, 7, 6, 5]
          }
    
        # Início da tabela
        table_top = pdf.cursor
        num_rows = notas.size + 1 
        num_columns = notas.values.first.size + 1 
        cell_height = 20
        table_height = cell_height * num_rows
        column_widths = [180, 60, 60, 60, 60]
        table_width = column_widths.inject(:+)
        table_initial_position = (pdf.bounds.right / 2) - (table_width / 2)
        pdf.move_cursor_to table_top
    
        # Desenha as linhas horizontais
        num_rows.times do |i|
          pdf.stroke_horizontal_line table_initial_position, table_initial_position + table_width, at: pdf.cursor
          pdf.move_down cell_height
        end
      
        pdf.stroke_horizontal_line table_initial_position, table_initial_position + table_width, at: pdf.cursor
        pdf.move_cursor_to table_top
  
        # Desenha as linhas verticais
        num_columns.times do |i|
          x_position = table_initial_position + column_widths.take(i).inject(0, :+)
          pdf.stroke_vertical_line pdf.cursor, pdf.cursor - table_height, at: x_position
        end
        x_position = table_initial_position + column_widths.inject(0, :+)
        pdf.stroke_vertical_line pdf.cursor, pdf.cursor - table_height, at: x_position
  
        # Adiciona o cabeçalho da tabela
        header = ["Disciplina", "1º Ano", "2º Ano", "3º Ano", "4º Ano"]
        header.each_with_index do |title, index|
          x_position = table_initial_position + column_widths.take(index).inject(0, :+)
          pdf.draw_text title, at: [x_position + 2, table_top - 15]
        end
    
        # Adiciona as notas à tabela
        notas.each_with_index do |(disciplina, notas), row|
          y_position = table_top - (row + 1) * cell_height - 15
          x_position = table_initial_position
          pdf.draw_text disciplina, at: [x_position, y_position]
          notas.each_with_index do |nota, column|
            x_position = table_initial_position + column_widths.take(column + 1).inject(0, :+)
            pdf.draw_text nota.to_s, at: [x_position + 2, y_position]
          end
        end
    
        pdf.move_down table_height + 20
  
        pdf.text "Certificamos que #{document.nome_aluno}, concluiu o 2º ano do ensino médio, no ano de #{Time.zone.now.year}, de acordo com a Lei Vigente, tendo obtido os resultados constantes neste Histórico Escolar, dando-lhe o direito de prosseguimento de estudos no Ensino Médio.", align: :center, size: 10
        pdf.move_down 30
        pdf.text "João Pessoa - PB, #{Time.zone.now.strftime('%d/%m/%Y')}", align: :right, size: 12

        pdf.stroke do
          pdf.horizontal_line(0, 200)
        end
        pdf.move_down 25
        pdf.text "Coordenador(a)", align: :left, size: 12
      end
    end
  end
  