Likes to Playlists
===================
I wrote because SoundCloud removed the ability to add tracks to playlists (sets) from the mobile client. I use this extensively, so I just scripted my own workflow. TL;DR it adds anything you've liked to the playlist for this month.

Here's the logic:
- Get all playlists (sets)
- Get all favorites (likes)
- Select the playlist named as `Playlist_permalink_title` as `this_month_playlist`. Note that if multiple playlists are created with the same title, they're named as the downcase'd spaces-to-hyphens title, with things like apostrophes translated to hyphens for hte permalink. Beware.
- If the playlist `Playlist_permalink_title` can't be found, create it as `Playlist_actual_title`. If you're not sure if your `Playlist_permalink_title` and `Playlist_actual_title` line up, test it first.
- generate `favs_this_month` by cherry-picking favorites (from the most-recent `Page_size` ordered by `Pagination_order`) which are newer than `Favorites_to_add_date` (defaults: `200`, `created_at`, `DateTime.now.utc.beginning_of_month` (SC stores all dates as UTC))
- If all of the items in `favs_this_month` exist in `this_month_playlist`, do nothing. This accounts for `this_month_playlist` having things not present in `favs_this_month`
- If there are tracks IDs in `favs_this_month` not present in `this_month_playlist`, combine the track IDs from `favs_this_month` and `this_month_playlist` and update `this_month_playlist` on SoundCloud (and locally).
- Display any tracks being added, along with `favs_this_month` and `this_month_playlist`

How 2
======
You'll need an app key and secret for this. Get that [here](http://soundcloud.com/you/apps/new).

Put those and your SoundCloud username / password in `oauth-config.yaml` in the same directory as this script. An example for you to edit is included as `oauth-config.yaml.dist`. This is the [OAuth Uesr Credentials Flow](https://developers.soundcloud.com/docs/api/guide#authentication) if you're wondering, and yes; this could be much simpler if SoundCloud had a web UI to generate OAuth user tokens for developers.

To base64-encode your password, do something like this: `echo -n 'your-password-here' |base64`

To install the requirements, a `bundle install` should do it. Built for Ruby 2.1.

This is quite rough right now, and there's an issue where if the thing you liked wasn't cerated in the past month, it won't be added. It looks like SoundCloud doesn't track the date of when you add something, so I'm not sure how to get around that. Please submit a PR if you have suggestions (line 50).
