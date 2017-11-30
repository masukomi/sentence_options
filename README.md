[![Build Status](https://travis-ci.org/masukomi/sentence_options.svg?branch=master)](https://travis-ci.org/masukomi/sentence_options)

# sentence_options

A command line options parser for sentence-like human interfaces to your apps. 

If you wanted, for example to tell your app to tag the last item with "urgent" 
a typical option parser would require inputs like this:

```
my_app --action tag --what item --which last --tag urgent
```

With sentence_options you can allow your users to interact with your app like
this: 

```
my_app tag last item with urgent
# or
my_app tag last item urgent
```

It makes the base assumption that each command to your app will start with a
unique keyword. In the example above that keyword is "tag". It finds the
matching `Command` and passes it the remaining arguments to a `Proc` to be
handled. 


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  sentence_options:
    github: masukomi/sentence_options
```

## Usage

```crystal
require "sentence_options/sentence_options"

# initialize a new Parser
parser = SentenceOptions::Parser.new("Usage: do stuff with things")
# each command needs a Proc to handle the arguments
# this is a slightly complex example of how to handle tagging an item.
tag_proc = Proc(Array(String), Bool).new{ |args| 
  args = args.reject{|x| x == "with"} # don't need that
  identifier = args[0]
  thing = args[1]
  tags = args[2..-1] # everything else is a tag
  begin
    if thing == "item"
      Item.find(identifier).tag(tags)
    else
      NotItem.find(identifier).tag(tags)
    end
    true
  rescue 
    false # or maybe raise a custom exception
  end
   })
# new command with the proc
tag_command = SentenceOptions::Command.new("tag",
                                      "tag <identifier> <thing> [with] <tag>",
                                      tag_proc)
# add the Command to the Parser
parser.add_command(tag_command)

# parse the arguments passed in
successful = parser.parse(ARGV) # will also return false if given an empty array
STDERR.puts parser.banner unless successful
```

## Development
Before developing any feature please create an issue where you describe your idea.

Before working on a bug, please make sure there isn't already a GitHub Issue for it. If there is, make sure no-one's already working on it. If there isn't please create one. 

If you have a useful sounding idea I'll probably want to merge it. If you've
already coded up improvements for yourself, go ahead and file an Issue
describing it and then make a PR. 

Note: while I really want to add your contributions, no PR will be merged
without passing unit tests.

Please ping me at @masukomi on Twitter so that I see your Issue promptly.

## Contributing

1. Fork it ( https://github.com/masukomi/sentence_options/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
    * Please include [unit tests]((https://crystal-lang.org/api/Spec.html)) 
      and [documentation](https://crystal-lang.org/docs/conventions/documenting_code.html).
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
6. Poke [@masukomi](https://twitter.com/masukomi) on Twitter to make sure it gets seen promptly.

## Contributors

- [masukomi](https://github.com/masukomi) masukomi - creator, maintainer
