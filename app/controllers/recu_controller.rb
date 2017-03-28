class RecuController < ApplicationController
  def index
    # @yolo = Offer.all
  end

  def show
    # @pdf = WickedPdf.new.pdf_from_url('http://localhost:3000/recu')
    @id = "idid"
    @pdf = WickedPdf.new.pdf_from_string(
      render_to_string(:pdf => @id,
        :template => "recu/index.pdf.erb",
        :locals => { :loc=>"locust" },
        :encoding => 'UTF-8')
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
