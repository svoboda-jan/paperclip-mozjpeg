# About

This repository contains the ruby library which adds file processor to compress JPEG images uploaded using the [paperclip](https://github.com/thoughtbot/paperclip) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paperclip-mozjpeg'

# To use bundled binaries of MozJPEG 3.0 for Mac OS X, Linux and Windows add:
gem 'mozjpeg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paperclip-mozjpeg
    
To install bundled binaries (must `require 'mozjpeg'` if not using bundler):

    $ gem install mozjpeg

## Usage

```ruby
class User < ActiveRecord::Base
  has_attached_file :avatar, :styles => {
    :tiny => {
      geometry: '190x190>',
      mozjpeg_options: '-quality 30', 
    },
    :large => {
      geometry: '1280x1280>',
      mozjpeg_options: '-quality 70 -quant-table 2 -notrellis',
    }
  },
  processors: [ :thumbnail, :mozjpeg ]
end
```

If you don't want to use the `mozjpeg` gem bundled binaries and want to specify the path to mozjpeg (cjpeg) or it is not in the `PATH` use the `mozjpeg_path` option.


## License

This gem is licensed under the MIT license.

## Contributing

1. Fork it ( https://github.com/svoboda-jan/paperclip-mozjpeg/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
