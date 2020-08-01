require 'open-uri'
require 'json'
require 'csv'
require 'yaml'
# require 'pry-byebug'

module Api
  module V1
    class PackagesController < ApplicationController
      def index
        # byebug
        # @id = @packages.last.id + 1
        # @packages = []
        # @id = 1
        # @packages = []
        parse
        # @packages = Package.all
        # set_link
        # set_rev

        Package.all.each do |package|
          package.link = "http://localhost:3000/#{api_v1_package_path(package.id)}"
          package.save
        end

        Package.all.each do |test_pack|
        rev_string = ""
        rev_array = []
        # rev_hash = {}
          # test_pack = test_pack
            Package.all.each do |package|
          if package.depends != nil
            # byebug
            if package.depends.include?(test_pack.name)
              # rev_hash[package.name] = package.link
              # test_pack.rev_depends = rev_hash
              if rev_string == ""
              rev_string = "#{package.link}"
              test_pack.rev_depends = rev_string
              test_pack.save
              else
                rev_array << rev_string
                rev_array << "#{package.link}"
                test_pack.rev_depends = rev_array
                test_pack.save
              # byebug
              end
            end
          end
        end
              # byebug
      end

        # @packages.each do |packages|

        json = render json: {
          status: 'SUCCES',
          message: 'Loaded packages',
          data:Package.all},
          status: :ok
        end

        def show
          package = Package.find(params[:id])
        # byebug
        # package = @packages.find(params[:id])
        render json: {status: 'SUCCES', message: 'Loaded package', data:package}, status: :ok
      end

      def parse
        # # @packages = []
        # f = File.open('status')
        Package.destroy_all

        r = File.read('status')
        s = r.split("\n\n")

        # thing = YAML.load_file('status')
        # byebug
        # split = thing.split("\n\n")
       # things = JSON.parse(File.read('status'))
        # thing = JSON.parse(packages)

        # filepath = 'status'
        # string_packages = File.read(filepath)

        # splitted = string_packages.split("\n\n")

        # byebug

        s.each do |string|
          # byebug
          hash = YAML.load(string)
          @package = Package.new(name: hash["Package"], description: hash["Description"], depends: hash["Depends"])
          @package.save
        # @packages <<  @package
        # @id += 1
      end

        # puts thing.inspect
        # byebug

        # byebug
        # repository = Repository.new(file)
      end


      def set_link
        @packages.each do |package|
          package.link = "http://localhost:3000/#{api_v1_package_path(package.id)}"
        end
      end

      def set_rev
        Package.all.each do |test_pack|
        rev_array = []
          @test_pack = test_pack
            Package.all.each do |package|
          if package.depends != nil
            # byebug
            if package.depends.include?(test_pack.name)
              rev_array << package.name
              test_pack.rev_depends = rev_array
              # byebug
            end
          end
        end
              @test_pack.save
              # byebug
      end
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
