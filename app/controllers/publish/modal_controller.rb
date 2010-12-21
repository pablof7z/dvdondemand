class Publish::ModalController < PublishController
	layout false
	before_filter :load_product

	def load_product
		@product = Product.find(params[:product_id])
	end
end
