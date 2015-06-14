# DocPad Configuration File
# http://docpad.org/docs/config

moment = require('moment')

# Environment
envConfig = process.env

# Define the DocPad Configuration
docpadConfig = {
    templateData:
        site:
            url: (websiteUrl = "www.ramjeeganti.com")
            title: "Unknown Unknown"
            author: "Ramjee Ganti"
            email: "hello@ramjeeganti.com"
            timestamp: new Date().getTime()

            social:
                # Twitter
                twitter:
                    name: 'Twitter'
                    url: "//twitter.com/#{envConfig.TWITTER_USERNAME}"
                    #profile:
                    # feeds:
                    #   tweets: 'twitter'

                # GitHub
                github:
                    name: 'GitHub'
                    url: "//github.com/#{envConfig.GITHUB_USERNAME}"
                    profile:
                        feeds:
                            user: 'githubUser'
                            repos: 'githubRepos'
                # Flickr
                flickr:
                    name: 'Flickr'
                    url: "//www.flickr.com/people/#{envConfig.FLICKR_USER_ID}"
                    profile:
                        feeds:
                            user: 'flickrUser'
                            photos: 'flickrPhotos'
        # -----------------------------
        # Helper Functions
        getPreparedTitle: ->
            # if we have a document title, then we should use that and suffix the site's title onto it
            if @document.title
                "#{@document.title} | #{@site.title}"
            # if our document does not have it's own title, then we should just use the site's title
            else
                @site.title

        # Get the prepared site/document description
        getPreparedDescription: ->
            # if we have a document description, then we should use that, otherwise use the site's description
            @document.description or @site.description

        # Get the prepared site/document keywords
        getPreparedKeywords: ->
            # Merge the document keywords with the site keywords
            @site.keywords.concat(@document.keywords or []).join(', ')

        getFormattedDate: (date)  ->
            moment(date).format 'D MMM YYYY'

        getTagUrl: (tag) ->
            slug = tag.toLowerCase().replace(/[^a-z0-9]/g, '-').replace(/-+/g, '-').replace(/^-|-$/g, '')
            "/tags/#{slug}/"
    # Ignore Custom Patterns
    # Can be set to a regex of custom patterns to ignore from the scanning process
    ignoreCustomPatterns: /DRAFT/

    collections:
        posts: ->
            @getCollection("html").findAllLive({relativeOutDirPath: 'blog'}, [date:-1]).on "add", (model) ->
                model.setMetaDefaults({
                    layout:'post',
                    author: 'Ramjee Ganti',
                    date: moment(new Date).format 'YYYY-MM-DD hh:ss'
                })
        cleanurls: ->
            @getCollection('html').findAllLive(skipCleanUrls: $ne: true)

    plugins:
        tags:
            findCollectionName: 'posts'
            extension: '.html'
            injectDocumentHelper: (document) ->
                document.setMeta(
                    layout: 'tags'
                )
        dateurls:
            cleanurl: true
            trailingSlashes: false
            keepOriginalUrls: false
            collectionName: 'posts'
            dateIncludesTime: true
        paged:
            cleanurl: true
            startingPageNumber: 2
        cleanurls:
            trailingSlashes: false
            collectionName: 'cleanurls'
}

# Export the DocPad Configuration
module.exports = docpadConfig