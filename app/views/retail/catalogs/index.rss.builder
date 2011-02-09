xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "OnDemand Retail Catalogs"
    xml.link retail_catalogs_url
    xml.description "All available product Catalogs in our Web Store."
    @catalogs.each do |catalog|
      xml.item do
        xml.title catalog.title
        xml.link retail_catalog_url(catalog)
        xml.description "#{catalog.description} (Published by #{catalog.publisher.full_name})"
        xml.guid retail_catalog_url(catalog)
      end
    end
  end
end
