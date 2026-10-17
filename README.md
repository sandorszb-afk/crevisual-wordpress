# CREVISUAL WordPress

WordPress Apache container for Railway. The Dockerfile keeps only the prefork Apache MPM. Railway should use the Dockerfile build and the image default start command. Existing MySQL, WordPress environment variables and wp-content volume must remain intact.
