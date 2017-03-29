class RecuController < ApplicationController
  def index
    # @yolo = Offer.all
  end

  def show
    # @pdf = WickedPdf.new.pdf_from_url('http://localhost:3000/recu')
    receipt_id = 1
    amount = 2
    payment_method = "CHEQUE"
    adress = "La bas"
    name = "Martin"
    date = "01/01/1970"

    @id = "idid"
    @pdf = WickedPdf.new.pdf_from_string(
      render_to_string("recu/index.html.erb", :locals => {
        :receipt_id => receipt_id,
        :amount => amount,
        :payment_method => payment_method,
        :adress => adress,
        :date => date,
        :name => name })
    )
    @filename ||= "#{Rails.root}/public/pdfs/#{@id}.pdf"
    @save_path ||= Rails.root.join('public/pdfs',@id + '.pdf')
    @access_path ||= "pdfs/#{@id}.pdf"

    File.open(@save_path, 'wb') do |file|
      file << @pdf
    end
    # render @pdf
  end
end
