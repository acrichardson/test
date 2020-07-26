require 'json'

module Api
  module V1
    class PackagesController < ApplicationController
      def index
        packages = Package.all
        # packages = Package.order('created_at DESC');
        json = render json: {status: 'SUCCES', message: 'Loaded packages', data:packages}, status: :ok
          # JSON.pretty_generate(JSON.parse(json))
      end

      def show
        package = Package.find(params[:id])
        render json: {status: 'SUCCES', message: 'Loaded package', data:package}, status: :ok
      end

      ##NOT NESSECARY
      # def create
      #   package = Package.new(package_params)

      #   if package.save
      #     render json: {status: 'SUCCES', message: 'Saved package', data:package}, status: :ok
      #   else
      #     render json: {status: 'ERROR', message: 'Package not Saved!', data:package.errors}, status: :unprocessable_entitiy
      # end

      # def destroy
      #   package = Package.find(params[:id])
      #   article.destroy
      #   render json: {status: 'SUCCES', message: 'Deleted package', data:package}, status: :ok
      # end

      # def update
      #   package = Package.find(params[:id])
      #   if package.update_attributes(package_params)
      #     render json: {status: 'SUCCES', message: 'Updated package', data:package}, status: :ok
      #   else
      #     ender json: {status: 'ERROR', message: 'Deleted package', data:package}, status: :unprocessable_entitiy
      # end
      private

      def package_params
        params.permit(:name, :description, :depends, :rev_depends)
      end
    end
  end
end
