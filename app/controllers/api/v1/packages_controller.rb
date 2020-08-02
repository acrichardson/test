require 'json'
require 'yaml'

module Api
  module V1
    class PackagesController < ApplicationController
      def index
        @packages = Package.all
        if @packages.all == []
          parse
          set_link
          set_rev
        end

        json = render json: {
          status: 'SUCCES',
          message: 'Loaded packages',
          data:Package.all},
          status: :ok
        end

        def show
          package = Package.find(params[:id])
          render json: {status: 'SUCCES', message: 'Loaded package', data:package}, status: :ok
        end

        # There must be a better way
        def parse
          Package.destroy_all
          # r = File.read('status_no2')
          r = File.read('var/lib/dpkg/status')
          split = r.split("\n\n")
          split = split.each { |string| string.gsub!(":\n  ", " ") }
          split = split.each { |string| string.gsub!(":\n .", " ") }
          split = split.each { |string| string.gsub!("o: ", "o") }
          split = split.each { |string| string.gsub!("like: ", "like") }
          split = split.each { |string| string.gsub!("cense:", "cense ") }
          split = split.each { |string| string.gsub!("lets: ", "lets ") }
          split = split.each { |string| string.gsub!(" as:", " as") }
          split = split.each { |string| string.gsub!(":\n <", "\n <") }
          split = split.each { |string| string.gsub!("short: ", "short ") }
          split = split.each { |string| string.gsub!(":\n ", ": ") }
          split = split.each { |string| string.gsub!("includes:", "includes") }
          split = split.each { |string| string.gsub!("include:", "include") }
          split = split.each { |string| string.gsub!(":\n *", " ") }
          split = split.each { |string| string.gsub!(":\n", "\n") }

          split.each do |string|
            hash = YAML.load(string)
            @package = Package.new(name: hash["Package"], description: hash["Description"], depends: hash["Depends"])
            @package.save
          end
        end

        def set_link
          root = "http://localhost:3000/"
          @packages.each do |package|
            package.link = "#{root}#{api_v1_package_path(package.id)}"
            package.save
          end
        end

        def set_rev
          Package.all.each do |test_pack|
            rev_string = ''
            rev_array = []
            Package.all.each do |package|
              if package.depends != nil
                if package.depends.include?(test_pack.name)
                  rev_array << { package.name => package.link }.to_s
                  test_pack.rev_depends = rev_array
                  test_pack.save
                end
              end
            end
          end
        end

    end
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
      #   package.destroy
      #   render json: {status: 'SUCCES', message: 'Deleted package', data:package}, status: :ok
      # end

      # def update
      #   package = Package.find(params[:id])
      #   if package.update_attributes(package_params)
      #     render json: {status: 'SUCCES', message: 'Updated package', data:package}, status: :ok
      #   else
      #     ender json: {status: 'ERROR', message: 'Deleted package', data:package}, status: :unprocessable_entitiy
    # end
      # def package_params
      #   params.permit(:name, :description, :depends, :rev_depends)
    # end
