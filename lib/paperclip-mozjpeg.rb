require "paperclip-mozjpeg/version"
require 'paperclip'

module Paperclip

  # Handles JPEG and PNG compression.
  class Mozjpeg < Processor
    PROCESSABLE_CONTENT_TYPES = ['image/jpeg', 'image/png']

    attr_accessor :whiny, :mozjpeg_options

    # Compresses the +file+ using MozJPEG's cjpeg command.
    # Compression will raise no errors unless +whiny+ is true
    # (which it is, by default).
    #
    # Options include:
    #
    #   +geometry+ - the desired width and height of the thumbnail (required)
    #   +whiny+ - whether to raise an error when processing fails. Defaults to true
    def initialize(file, options = {}, attachment = nil)
      super
      @geometry             = options[:geometry].to_s
      @mozjpeg_options      = options[:mozjpeg_options]
      @whiny                = options.fetch(:whiny, true)
      @use_system_binaries  = options.fetch(:use_system_binaries, false)
      @mozjpeg_path         = options.fetch(:mozjpeg_path, nil)
      @current_format       = File.extname(@file.path)
      @basename             = File.basename(@file.path, @current_format)
    end

    # Performs the compression of the +file+. Returns the Tempfile
    # that contains the new image.
    def make
      return @file unless PROCESSABLE_CONTENT_TYPES.include? Paperclip::ContentTypeDetector.new(@file.path).detect

      src = @file
      filename = [@basename, @format ? ".#{@format}" : ""].join
      dst = TempfileFactory.new.generate(filename)

      begin
        parameters = []
        parameters << mozjpeg_options
        parameters << "-outfile :dest"
        parameters << ":source"

        parameters = parameters.flatten.compact.join(" ").strip.squeeze(" ")

        success = cjpeg(parameters, :source => "#{File.expand_path(src.path)}", :dest => File.expand_path(dst.path))
      # dynamic exception handling to support paperclip using Cocaine or Terrapin gem
      rescue Class.new { def self.===(ex); ex.class.name.end_with?("::ExitStatusError"); end }
        raise Paperclip::Error, "There was an error processing the file for #{@basename}" if @whiny
      rescue Class.new { def self.===(ex); ex.class.name.end_with?("::CommandNotFoundError"); end }
        raise Paperclip::Errors::CommandNotFoundError.new("Could not run the `cjpeg` command. Please install MozJPEG.")
      end

      dst
    end

    def cjpeg(arguments = "", local_options = {})
      if !@use_system_binaries && defined?(::Mozjpeg::VERSION)
        cmd = ::Mozjpeg.cjpeg_path
      end
      cmd ||= ( @mozjpeg_path || 'cjpeg')
      Paperclip.run(cmd, arguments, local_options)
    end

  end
end
