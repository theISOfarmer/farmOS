# Inherit from the Drupal 7 image on Docker Hub.
FROM drupal:7

# Install dependencies via apt-get.
RUN apt-get update && apt-get install -y \
  git \
  libgeos-dev \
  unzip

# Install Drush.
RUN php -r "readfile('http://files.drush.org/drush.phar');" > drush && \
    chmod +x drush && \
    mv drush /usr/local/bin

# Build farmOS with Drush Make.
COPY build-farm.make /farmOS/build-farm.make
COPY drupal-org-core.make /farmOS/drupal-org-core.make
WORKDIR /farmOS
RUN cd /farmOS && drush make build-farm.make farm

# Replace /var/www/html with farmOS.
RUN rm -rf /var/www/html && ln -s /farmOS/farm /var/www/html

# Change ownership of the Drupal sites folder to www-data.
RUN chown -R www-data:www-data /farmOS/farm/sites
