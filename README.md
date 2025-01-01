### Clear Github gists

Used to bulk delete gists that may have accidentally been created.

Will need a gist enabled GH PAT

Usage: 
```
> irb
irb(main):014> require './lib/remove_gists'
irb(main):014> client = RemoveGists.new
irb(main):014> client.bulk_delete
```



