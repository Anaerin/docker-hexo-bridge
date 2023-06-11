# docker-hexo-bridge
A docker-compose setup for Hexo (with Hexo-Bridge for administration) and nginx to host the static site only

## Why?
Well, hexo-bridge has an admin interface it exposes (On port 4000 in this setup), along with hosting the regular static site. But the admin interface (like hexo-admin) has no security measures whatsoever. So for security (and improved performance) this setup has hexo-bridge listening on port 4000, and the static site generated and served by nginx on port 80 (in a read-only way). So you use port 4000/admin to edit the site, and expose port 80 as your internet-facing service. If resources are scarce, you could also pause/stop the hexo-bridge container, and only bring it up when you want to do changes, but that's beyond the scope of this simple stack.

## Any problems with it?
Not really. It all works, though hexo is running twice in the container, as for some reason the `hexo server` isn't generating files when they're updated. Fortunately, `hexo generate --watch` can run in the background and will automatically regenerate as needed to ensure the static site will always be up to date.

## Things to note:
If the `app` folder exists, it will be checked to see if it has any contents. This is to make restarting easy. In theory it should (on first startup) initialize the site into that folder. The static site will (by default) be in the `public` folder so if you don't want to use the bundled nginx instance you can just point your hosting at that folder.