xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title @catalog.title
    xml.link retail_catalog_url(@catalog)
    xml.description "#{@catalog.description} (Published by #{@catalog.publisher.full_name})"
    @catalog.products.each do |product|
      xml.item do
        xml.title product.title
        xml.link retail_product_url(product)
        xml.description product.description
        xml.guid retail_product_url(product)
      end
    end
  end
end
