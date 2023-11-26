module DataFormatHelper
    def formatar_data(data)
      data.strftime('%d/%m/%Y') if data
    end
end