require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe 'GET /products' do
    it 'should return success status' do
      get '/products'

      expect(response).to have_http_status(200)
    end

    it 'should return a products list' do
      products = create_list(:product, 3)

      get '/products'

      products.each do |product|
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.value)
        expect(response.body).to include(product.description)
      end
    end
  end

  describe 'POST /products' do
    context 'valid parameters' do
      it 'should return success status' do
        product_attributes = FactoryBot.attributes_for(:product)

        post '/products', params: {
          product: product_attributes
        }

        expect(response).to have_http_status(201)
      end

      it 'should create a product' do
        product_attributes = FactoryBot.attributes_for(:product)

        post '/products', params: {
          product: product_attributes
        }

        expect(Product.last).to have_attributes(product_attributes)
      end
    end

    context 'invalid parameters' do
      it 'should not create a product' do
        expect {
          post '/products', params: {
            product: { name: '', value: '', description: '' }
          }
        }.to_not change(Product, :count)
      end
    end
  end

  describe 'PUT /products/:id' do
    context 'valid parameters' do
      it 'should return success status' do
        product = create(:product)

        put "/products/#{product.id}", params: {
          product: { name: 'Golden Apple' }
        }

        expect(response).to have_http_status(200)
      end

      it 'should edit the product' do
        product = create(:product)

        put "/products/#{product.id}", params: {
          product: { name: 'Golden Apple' }
        }

        expect(Product.last.name).to eq('Golden Apple')
      end
    end

    context 'invalid parameters' do
      it 'should not edit the product' do
        product = create(:product)

        put "/products/#{product.id}", params: {
          product: { name: '' }
        }

        expect(Product.last.name).to eq(product.name)
      end

      it 'should return product not found error' do
        put '/products/999', params: {
          params: { name: 'Golden Apple' }
        }

        expect(response.body).to include('Product not found')
      end
    end
  end
end