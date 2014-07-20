cheerio = require('cheerio')
urllib = require('url')

exports.fixLinks = (html, url) ->
  $ = cheerio.load(html)
  for key,val of $('link[rel=stylesheet]')
    if val.attribs and val.attribs.href
      console.log(val.attribs.href)
      val.attribs.href = remotizeURL(val.attribs.href, url)
      console.log(val.attribs.href)
  for key,val of $('script')
    if val.attribs and val.attribs.src
      console.log(val.attribs.src)
      val.attribs.src = remotizeURL(val.attribs.src, url)
      console.log(val.attribs.src)

  for key,val of $('img')
    if val.attribs and val.attribs.src
      console.log(val.attribs.src)
      val.attribs.src = remotizeURL(val.attribs.src, url)
      console.log(val.attribs.src)

  $.html()


remotizeURL = (url, page_url) ->
  parsedProxiedUrl = urllib.parse(page_url)
  host = parsedProxiedUrl.protocol + "//" + parsedProxiedUrl.hostname
  path = removeEndOfPath(parsedProxiedUrl.pathname)

  isAbsoluteURLRegex = /^(\/\/|http|javascript|data:)/i
  unless isAbsoluteURLRegex.test(url)
    if host[host.length - 1] is "/" and url[0] is "/"
      url = host + url.substring(1)
    else if host[host.length - 1] isnt "/" and url[0] isnt "/"
      url = host + path + "/" + url
    else
      url = host + url

  url

removeEndOfPath = (path) ->
  arr = path.split('/')
  return arr.splice(0, arr.length-1).join('/')



the_url = "https://developer.chrome.com/extensions/windows"
html = """
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="HandheldFriendly" content="True">
    <meta name="MobileOptimized" content="320">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="cleartype" content="on">
    <link type="image/ico" rel="icon" href="//www.google.com/images/icons/product/chrome-32.png">

    <link href="/static/css/out/site.css" rel="stylesheet" type="text/css">
    <link href="/static/css/print.css" rel="stylesheet" type="text/css" media="print">
    <link href="/static/css/prettify.css" rel="stylesheet" type="text/css">
    <link href='//fonts.googleapis.com/css?family=Open+Sans:400,700|Source+Code+Pro' rel='stylesheet' type='text/css'>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-41980257-1');
  ga('create', 'UA-49880327-5', {'name': 'chromeDocs'});
  ga('send', 'pageview');
  ga('chromeDocs.send', 'pageview');

</script>

    <title>chrome.windows - Google Chrome</title>
  </head>

  <body>
    <div id="gc-container">
    <a href="#gc-pagecontent" class="element-invisible element-focusable">Skip to main content</a>

    <header id="topnav" role="banner">
      <div id="logo">
        <a href="/">
          <img alt="Chrome: developer" src="/static/images/chrome-logo_2x.png">
        </a>
        <span class="collase-icon"><!-- <img src="/static/images/burger-icon.png" class="collase-icon">--></span>
      </div>
      <nav id="fatnav" role="navigation">
      <ul>
          <li class="pillar">
            <span class="toplevel">Devtools</span>
            <ul class="expandee">
                <li class="submenu">Learn Basics
                  <ul>
                      <li class="category">
                        <a href="/devtools/index">
                        Overview
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/authoring-development-workflow">
                        Development Workflow
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/console">
                        Using the Console
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/tips-and-tricks">
                        Tips &amp; Tricks
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/videos">
                        Additional Resources
                        </a>
                        <ul>
                            <li><a href="/devtools/docs/videos">Videos</a>
                            </li>
                            <li><a href="/devtools/docs/blog-posts">Blog Posts</a>
                            </li>
                            <li><a href="https://groups.google.com/forum/?fromgroups#!forum/google-chrome-developer-tools">Mailing List</a>
                            </li>
                            <li><a href="/devtools/docs/contributing">Contributing to DevTools</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Use Tools
                  <ul>
                      <li class="category">
                        <a href="/devtools/docs/dom-and-styles">
                        Inspecting &amp; Tweaking
                        </a>
                        <ul>
                            <li><a href="/devtools/docs/dom-and-styles">Editing Styles and the DOM</a>
                            </li>
                            <li><a href="/devtools/docs/css-preprocessors">Working with CSS Preprocessors</a>
                            </li>
                            <li><a href="/devtools/docs/resource-panel">Managing Application Storage</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/javascript-debugging">
                        Debugging JavaScript
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/mobile-emulation">
                        Mobile Emulation
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/remote-debugging">
                        Remote Debugging on Android
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/workspaces">
                        Saving Changes with Workspaces
                        </a>
                        <ul>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Performance &amp; Profiling
                  <ul>
                      <li class="category">
                        <a href="/devtools/docs/network">
                        Evaluating Network Performance
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/timeline">
                        Using the Timeline
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/demos/too-much-layout/index">
                        Timeline Demo: Layout Thrashing
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/cpu-profiling">
                        Profiling JavaScript Performance
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/javascript-memory-profiling">
                        JavaScript Memory Profiling
                        </a>
                        <ul>
                            <li><a href="/devtools/docs/javascript-memory-profiling">JavaScript Memory Profiling</a>
                            </li>
                            <li><a href="/devtools/docs/heap-profiling-summary">Demos</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Reference
                  <ul>
                      <li class="category">
                        <a href="/devtools/docs/console-api">
                        Console API Reference
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/commandline-api">
                        Command Line API Reference
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/integrating">
                        DevTools Extensions API
                        </a>
                        <ul>
                            <li><a href="/devtools/docs/integrating">Integrating with DevTools</a>
                            </li>
                            <li><a href="/devtools/docs/sample-extensions">Sample DevTools Extensions</a>
                            </li>
                            <li><a href="/devtools/docs/debugging-clients">Sample DevTools Protocol Clients</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/shortcuts">
                        Keyboard Shortcuts
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/settings">
                        Settings
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/debugger-protocol">
                        Remote Debugging Protocol
                        </a>
                        <ul>
                            <li><a href="/devtools/docs/debugger-protocol">Remote Debugging Protocol</a>
                            </li>
                            <li><a href="/devtools/docs/protocol/1.1/index">Version 1.1</a>
                            </li>
                            <li><a href="/devtools/docs/protocol/1.0/index">Version 1.0</a>
                            </li>
                            <li><a href="/devtools/docs/protocol/0.1/index">Version .1</a>
                            </li>
                            <li><a href="/devtools/docs/protocol/tot/index">Tip-of-tree</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
            </ul>
          </li>
          <li class="pillar">
            <span class="toplevel">Multi-device</span>
            <ul class="expandee">
                <li class="submenu">Getting Started
                  <ul>
                      <li class="category">
                        <a href="/multidevice/index">
                        Chrome for a Multi-Device World
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/data-compression">
                        Data Compression Proxy
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/user-agent">
                        User Agents
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/mobile-emulation">
                        Mobile Emulation
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/devtools/docs/remote-debugging">
                        Remote Debugging
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/faq">
                        FAQ
                        </a>
                        <ul>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Chrome for Android
                  <ul>
                      <li class="category">
                        <a href="/multidevice/android/overview">
                        Overview
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/android/intents">
                        Android Intents with Chrome
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/android/installtohomescreen">
                        Add to Homescreen
                        </a>
                        <ul>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Chrome WebView
                  <ul>
                      <li class="category">
                        <a href="/multidevice/webview/overview">
                        WebView for Android
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/webview/gettingstarted">
                        Getting Started
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/webview/pixelperfect">
                        Pixel-Perfect UI
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/webview/workflow">
                        WebView Workflow
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/webview/tipsandtricks">
                        Tips &amp; Tricks
                        </a>
                        <ul>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Chrome for iOS
                  <ul>
                      <li class="category">
                        <a href="/multidevice/ios/overview">
                        Overview
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/ios/links">
                        Opening Links in Chrome
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/multidevice/ios/case-studies">
                        Case Studies
                        </a>
                        <ul>
                            <li><a href="/multidevice/ios/case-studies">Case Studies</a>
                            </li>
                            <li><a href="/multidevice/ios/pocket">Pocket</a>
                            </li>
                            <li><a href="/multidevice/ios/feedly">Feedly</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
            </ul>
          </li>
          <li class="pillar">
            <span class="toplevel">Platform</span>
            <ul class="expandee">
                <li class="submenu">Apps
                  <ul>
                      <li class="category">
                        <a href="/apps/about_apps">
                        Learn Basics
                        </a>
                        <ul>
                            <li><a href="/apps/about_apps">What Are Chrome Apps?</a>
                            </li>
                            <li><a href="/apps/first_app">Create Your First App</a>
                            </li>
                            <li><a href="/apps/app_architecture">App Architecture</a>
                            </li>
                            <li><a href="/apps/app_lifecycle">App Lifecycle</a>
                            </li>
                            <li><a href="/apps/contentSecurityPolicy">Content Security Policy</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/app_codelab1_setup">
                        Learn with Codelab
                        </a>
                        <ul>
                            <li><a href="/apps/app_codelab1_setup">1 - Set Up Development Environment</a>
                            </li>
                            <li><a href="/apps/app_codelab2_basic">2 - Create Basic App</a>
                            </li>
                            <li><a href="/apps/app_codelab3_mvc">3 - Create MVC</a>
                            </li>
                            <li><a href="/apps/app_codelab5_data">4 - Save &amp; Fetch Data</a>
                            </li>
                            <li><a href="/apps/app_codelab6_lifecycle">5 - Manage App Lifecycle</a>
                            </li>
                            <li><a href="/apps/app_codelab7_useridentification">6 - Access User's Data</a>
                            </li>
                            <li><a href="/apps/app_codelab8_webresources">7 - Access Web Resources</a>
                            </li>
                            <li><a href="/apps/app_codelab_10_publishing">8 - Publish App</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/samples">
                        Samples
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/offline_apps">
                        Develop in the Cloud
                        </a>
                        <ul>
                            <li><a href="/apps/offline_apps">Offline First</a>
                            </li>
                            <li><a href="/apps/app_external">Handling External Content</a>
                            </li>
                            <li><a href="/apps/app_storage">Storing Data</a>
                            </li>
                            <li><a href="/apps/inform_users">Keep Users Informed</a>
                            </li>
                            <li><a href="/apps/cloudMessaging">Cloud Messaging</a>
                            </li>
                            <li><a href="/apps/richNotifications">Rich Notifications</a>
                            </li>
                            <li><a href="/apps/app_identity">User Authentication</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/app_usb">
                        User Low-Level System Services
                        </a>
                        <ul>
                            <li><a href="/apps/app_usb">USB</a>
                            </li>
                            <li><a href="/apps/app_serial">Serial</a>
                            </li>
                            <li><a href="/apps/app_network">Network Communications</a>
                            </li>
                            <li><a href="/apps/app_bluetooth">Bluetooth</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/app_frameworks">
                        MVC Architecture &amp; Frameworks
                        </a>
                        <ul>
                            <li><a href="/apps/app_frameworks">About MVC Architecture</a>
                            </li>
                            <li><a href="/apps/angular_framework">Build Apps with AngularJS</a>
                            </li>
                            <li><a href="/apps/sencha_framework">Build Apps with SenchaJS</a>
                            </li>
                            <li><a href="/apps/game_engines">Game Engines</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/publish_app">
                        Distribute Apps
                        </a>
                        <ul>
                            <li><a href="/apps/publish_app">Publish Your App</a>
                            </li>
                            <li><a href="/apps/chrome_apps_on_mobile">Run Chrome Apps on Mobile</a>
                            </li>
                            <li><a href="/apps/google_wallet">Monetize Your App</a>
                            </li>
                            <li><a href="/webstore/one_time_payments">One-Time Payments</a>
                            </li>
                            <li><a href="/apps/analytics">Analytics</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/api_index">
                        Chrome Platform APIs
                        </a>
                        <ul>
                            <li><a href="/apps/api_index">JavaScript APIs</a>
                            </li>
                            <li><a href="/apps/manifest">Manifest File Format</a>
                            </li>
                            <li><a href="/apps/tags/webview">Webview Tag</a>
                            </li>
                            <li><a href="/apps/api_other">Web APIs</a>
                            </li>
                            <li><a href="/apps/app_deprecated">Disabled Web Features</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/apps/faq">
                        Help
                        </a>
                        <ul>
                            <li><a href="/apps/faq">FAQ</a>
                            </li>
                            <li><a href="https://groups.google.com/a/chromium.org/forum/#!forum/chromium-apps">Google Groups</a>
                            </li>
                            <li><a href="http://stackoverflow.com/questions/tagged/google-chrome-app">Stack Overflow</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Extensions
                  <ul>
                      <li class="category">
                        <a href="/extensions/overview">
                        Learn Basics
                        </a>
                        <ul>
                            <li><a href="/extensions/overview">Overview</a>
                            </li>
                            <li><a href="/extensions/hosting_changes">Hosting Changes</a>
                            </li>
                            <li><a href="/extensions/single_purpose">Extension Quality Guidelines FAQ</a>
                            </li>
                            <li><a href="/extensions/event_pages">Event Pages</a>
                            </li>
                            <li><a href="/extensions/content_scripts">Content Scripts</a>
                            </li>
                            <li><a href="/extensions/activeTab">activeTab Permission</a>
                            </li>
                            <li><a href="/extensions/whats_new">What's New?</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/extensions/getstarted">
                        Getting Started Tutorial
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/extensions/samples">
                        Samples
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/extensions/tut_migration_to_manifest_v2">
                        Develop Extensions
                        </a>
                        <ul>
                            <li><a href="/extensions/a11y">Accessibility</a>
                            </li>
                            <li><a href="/extensions/contentSecurityPolicy">Content Security Policy</a>
                            </li>
                            <li><a href="/extensions/xhr">Cross-Origin XHR</a>
                            </li>
                            <li><a href="/extensions/tut_debugging">Debugging</a>
                            </li>
                            <li><a href="/extensions/i18n">Internationalization</a>
                            </li>
                            <li><a href="/extensions/messaging">Message Passing</a>
                            </li>
                            <li><a href="/extensions/tut_migration_to_manifest_v2">Migrate to Manifest 2</a>
                            </li>
                            <li><a href="/extensions/tut_oauth">OAuth</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/extensions/hosting">
                        Distribute Extensions
                        </a>
                        <ul>
                            <li><a href="/extensions/hosting">Hosting</a>
                            </li>
                            <li><a href="/extensions/packaging">Packaging</a>
                            </li>
                            <li><a href="/webstore/one_time_payments">One-Time Payments</a>
                            </li>
                            <li><a href="/extensions/autoupdate">Autoupdating</a>
                            </li>
                            <li><a href="/extensions/external_extensions">Other Deployment Options</a>
                            </li>
                            <li><a href="/extensions/tut_analytics">Google Analytics</a>
                            </li>
                            <li><a href="/extensions/themes">Publishing Themes</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/extensions/api_index">
                        Chrome Platform APIs
                        </a>
                        <ul>
                            <li><a href="/extensions/api_index">JavaScript APIs</a>
                            </li>
                            <li><a href="/extensions/manifest">Manifest File Format</a>
                            </li>
                            <li><a href="/extensions/api_other">Web APIs</a>
                            </li>
                            <li><a href="/extensions/permission_warnings">Permission Warnings</a>
                            </li>
                            <li><a href="/extensions/permissions">Optional Permissions</a>
                            </li>
                            <li><a href="/extensions/match_patterns">Match Patterns</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/extensions/faq">
                        Help
                        </a>
                        <ul>
                            <li><a href="/extensions/faq">FAQ</a>
                            </li>
                            <li><a href="https://groups.google.com/a/chromium.org/forum/#!forum/chromium-extensions">Google Groups</a>
                            </li>
                            <li><a href="http://stackoverflow.com/tags/google-chrome-extension/info">Stack Overflow</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Native Client
                  <ul>
                      <li class="category">
                        <a href="/native-client/overview">
                        Learn Basics
                        </a>
                        <ul>
                            <li><a href="/native-client/overview">What Is Native Client?</a>
                            </li>
                            <li><a href="/native-client/nacl-and-pnacl">NaCl and PNaCl</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/sdk/download">
                        SDK
                        </a>
                        <ul>
                            <li><a href="/native-client/sdk/download">Download SDK</a>
                            </li>
                            <li><a href="/native-client/sdk/examples">Examples</a>
                            </li>
                            <li><a href="/native-client/sdk/release-notes">SDK Release Notes</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/devguide/tutorial/tutorial-part1">
                        Tutorial
                        </a>
                        <ul>
                            <li><a href="/native-client/devguide/tutorial/tutorial-part1">Part 1: Simple PNaCl Web App</a>
                            </li>
                            <li><a href="/native-client/devguide/tutorial/tutorial-part2">Part 2: SDK Build System and Chrome Apps</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/devguide/devcycle/building">
                        Development Cycle
                        </a>
                        <ul>
                            <li><a href="/native-client/devguide/devcycle/building">Building</a>
                            </li>
                            <li><a href="/native-client/devguide/devcycle/running">Running</a>
                            </li>
                            <li><a href="/native-client/devguide/devcycle/debugging">Debugging</a>
                            </li>
                            <li><a href="/native-client/devguide/devcycle/vs-addin">Debugging with Visual Studio</a>
                            </li>
                            <li><a href="/native-client/devguide/devcycle/dynamic-loading">Dynamic Linking and Loading with GlibC</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/devguide/coding/application-structure">
                        Coding Your Application
                        </a>
                        <ul>
                            <li><a href="/native-client/devguide/coding/application-structure">Application Structure</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/native-client-modules">Native Client Modules</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/3D-graphics">3D Graphics</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/audio">Audio</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/file-io">File I/O</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/nacl_io">The nacl_io Library</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/message-system">Messaging System</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/progress-events">Progress Events</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/url-loading">URL Loading</a>
                            </li>
                            <li><a href="/native-client/devguide/coding/view-focus-input-events">View Change, Focus, &amp; Input Events</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/devguide/distributing">
                        Distribute Your Apps
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/pepper_stable/index">
                        Pepper API Reference
                        </a>
                        <ul>
                            <li><a href="/native-client/pepper_stable/c/group___interfaces">Pepper C Interfaces</a>
                            </li>
                            <li><a href="/native-client/pepper_stable/c/group___structs">Pepper C Structures</a>
                            </li>
                            <li><a href="/native-client/pepper_stable/c/group___functions">Pepper C Functions</a>
                            </li>
                            <li><a href="/native-client/pepper_stable/c/group___enums">Pepper C Enums</a>
                            </li>
                            <li><a href="/native-client/pepper_stable/c/group___typedefs">Pepper C Typedefs</a>
                            </li>
                            <li><a href="/native-client/pepper_stable/c/global_defs">Pepper C Macros</a>
                            </li>
                            <li><a href="/native-client/pepper_stable/cpp/inherits">Pepper C++ Classes</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/glossary">
                        Additional Reference &amp; Versions
                        </a>
                        <ul>
                            <li><a href="/native-client/glossary">Glossary</a>
                            </li>
                            <li><a href="/native-client/reference/nacl-manifest-format">Native Client Manifest (nmf) Format</a>
                            </li>
                            <li><a href="/native-client/reference/pnacl-bitcode-abi">PNaCl Bitcode Reference Manual</a>
                            </li>
                            <li><a href="/native-client/reference/pnacl-c-cpp-language-support">PNaCl C/C++ Language Support</a>
                            </li>
                            <li><a href="/native-client/reference/sandbox_internals/index">Sandbox Internals</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/native-client/faq">
                        Help
                        </a>
                        <ul>
                            <li><a href="/native-client/faq">FAQ</a>
                            </li>
                            <li><a href="/native-client/help">Forums &amp; Issues Tracker</a>
                            </li>
                            <li><a href="/native-client/publications-and-presentations">Publications &amp; Presentations</a>
                            </li>
                            <li><a href="/native-client/community/security-contest/index">Security Contest Archive</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
                <li class="submenu">Store
                  <ul>
                      <li class="category">
                        <a href="/webstore/index">
                        What Is the Chrome Web Store?
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/overview">
                        What Can You Publish?
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/get_started_simple">
                        Tutorial: Getting Started
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/samples">
                        Samples
                        </a>
                        <ul>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/branding">
                        Branding
                        </a>
                        <ul>
                            <li><a href="/webstore/branding">Branding Guidelines</a>
                            </li>
                            <li><a href="/webstore/images">Supplying Images</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/money">
                        Monetizing
                        </a>
                        <ul>
                            <li><a href="/webstore/money">Monetizing Your App</a>
                            </li>
                            <li><a href="/webstore/identify_user">Using Google Accounts</a>
                            </li>
                            <li><a href="/webstore/check_for_payment">Checking for Payment</a>
                            </li>
                            <li><a href="/webstore/one_time_payments">One-Time Payments</a>
                            </li>
                            <li><a href="/webstore/pricing">Pricing</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/publish">
                        Publishing
                        </a>
                        <ul>
                            <li><a href="/webstore/publish">Publishing Tutorial</a>
                            </li>
                            <li><a href="/webstore/i18n">Internationalizing Your App</a>
                            </li>
                            <li><a href="/webstore/inline_installation">Using Inline Installation</a>
                            </li>
                            <li><a href="/webstore/rating">Rating Guidelines</a>
                            </li>
                            <li><a href="/webstore/program_policies">Program Policies</a>
                            </li>
                            <li><a href="/webstore/terms">Terms of Service</a>
                            </li>
                        </ul>
                      </li>
                      <li class="category">
                        <a href="/webstore/best_practices">
                        Help
                        </a>
                        <ul>
                            <li><a href="/webstore/best_practices">Best Practices</a>
                            </li>
                            <li><a href="/webstore/faq">FAQ</a>
                            </li>
                            <li><a href="https://groups.google.com/a/chromium.org/forum/#!forum/chromium-apps">Google Groups</a>
                            </li>
                            <li><a href="/webstore/articles">Articles</a>
                            </li>
                        </ul>
                      </li>
                  </ul>
                </li>
            </ul>
          </li>
        <li id="search">
          <img src="/static/images/search.png">
          <div class="expandee">

      <!-- override search styles set globally by site.css -->
      <style>
      .gsc-above-wrapper-area, .gsc-result-info {
        font-size: 11px;
      }
      .gs-webResult div, .gs-result div {
        line-height: initial;
      }
      .gs-webResult a, .gs-result a {
        text-decoration: none;
      }
      td.gcsc-branding-img-noclear, .gcsc-branding-img-noclear a {
        width: 51px;
        height: 15px;
        vertical-align: top;
      }
      .gsc-table-result, .gsc-thumbnail-inside, .gsc-url-top {
        padding: 0;
      }
      .gsc-control-cse tr, .gsc-control-cse td, .gsc-control-cse th {
       padding: inherit;
       border: none;
      }
      .gsc-control-cse {
        white-space: normal;
        border: none;
        padding: 0 1em;
      }
      #search .gsc-control-cse img {
        height: inherit;
        width: inherit;
      }
      .gsc-control-cse table {
        margin: initial;
      }
      .gsc-control-cse * {
        box-sizing: initial;
        -webkit-box-sizing: initial;
        -moz-box-sizing: initial;
      }
      #fatnav .expandee .gsc-control-cse a {
       padding: 0;
       color: inherit;
      }
      </style>

            <form id="chrome-docs-cse-search-form" action="http://google.com/cse">
              <input type="search" id="chrome-docs-cse-input" name="q" placeholder="What are you looking for?">
              <input type="hidden" name="cx" value="010997258251033819707:7owyldxmpkc" />
              <input type="hidden" name="ie" value="UTF-8" />
            </form>
            <gcse:searchresults-only gname="results"></gcse:searchresults-only>
          </div>
        </li>
      </ul>
      </nav>
          </header>

    <main id="gc-pagecontent" role="main">


<article>
  <div itemprop="articleBody" class="api">
    <h1>chrome.windows</h1>
    <table class="intro" id="intro">
      <tr>
        <td class="title">Description:</td>
        <td>
            Use the <code>chrome.windows</code> API to interact with browser windows. You can use this API to create, modify, and rearrange windows in the browser.
                    <br>
        </td>
      </tr>
      <tr>
        <td class="title">Availability:</td>
        <td>
            Stable since Chrome 5.
            <br>
        </td>
      </tr>
      <tr>
        <td class="title">Permissions:</td>
        <td>
            The <code>chrome.windows</code> API can be used
             without declaring any permission.
             However, the <code>"tabs"</code> permission is
             required in order to populate the
             <code><a href="tabs#property-Tab-url">url</a></code>,
             <code><a href="tabs#property-Tab-title">title</a></code>, and
             <code><a href="tabs#property-Tab-favIconUrl">favIconUrl</a></code> properties of
             <code><a href="tabs#type-Tab">Tab</a></code> objects.
            <br>
        </td>
      </tr>
    </table>
    <section>
      <h2 id="manifest">Manifest</h2>
      <p>
      When requested, a <code><a href=windows#type-Window>windows.Window</a></code>
      will contain an array of <code><a href=tabs#type-Tab>tabs.Tab</a></code> objects.

      You must declare the <code>"tabs"</code> permission in your
      <a href="manifest">manifest</a> if you require access to the
      <code><a href=tabs#property-Tab-url>url</a></code>,
      <code><a href=tabs#property-Tab-title>title</a></code>, or
      <code><a href=tabs#property-Tab-favIconUrl>favIconUrl</a></code> properties of
      <code><a href=tabs#type-Tab>tabs.Tab</a></code>.
      For example:
      </p>

      <pre data-filename="manifest.json">
      {
        "name": "My extension",
        ...
        <b>"permissions": ["tabs"]</b>,
        ...
      }
      </pre>

      <h2 id="current-window">The current window</h2>

      <p>Many functions in the extension system
      take an optional <var>windowId</var> parameter,
      which defaults to the current window.
      </p>

      <p>The <em>current window</em> is the window that
      contains the code that is currently executing.
      It's important to realize that this can be
      different from the topmost or focused window.
      </p>

      <p>For example, say an extension
      creates a few tabs or windows from a single HTML file,
      and that the HTML file
      contains a call to
      <a href=tabs#method-query>tabs.query</a>.
      The current window is the window that contains the page that made
      the call, no matter what the topmost window is.
      </p>

      <p>In the case of the <a href="event_pages">event page</a>,
      the value of the current window falls back to the last active window. Under some
      circumstances, there may be no current window for background pages.
      </p>

      <h2 id="examples"> Examples </h2>

      <p>
      <img src="/static/images/windows.png"
           width="561" height="224" alt="Two windows, each with one tab" />
      <br>
      You can find simple examples of using the windows module in the
      <a href="http://src.chromium.org/viewvc/chrome/trunk/src/chrome/common/extensions/docs/examples/api/windows/">examples/api/windows</a>
      directory.
      Another example is in the
      <a href="http://src.chromium.org/viewvc/chrome/trunk/src/chrome/common/extensions/docs/examples/api/tabs/inspector/tabs_api.html?content-type=text/plain">tabs_api.html</a> file
      of the
      <a href="http://src.chromium.org/viewvc/chrome/trunk/src/chrome/common/extensions/docs/examples/api/tabs/inspector/">inspector</a>
      example.
      For other examples and for help in viewing the source code, see
      <a href="samples">Samples</a>.
      </p>
    </section>
    <section id="toc">
    <h2>Summary</h2>
    <table class="api-summary">
      <tr>
        <tr><th colspan="2">Types</th></tr>
          <tr><td><a href="#type-Window">Window</a></td></tr>
        <tr><th colspan="2">Properties</th></tr>
          <tr><td><a href="#property-WINDOW_ID_NONE">WINDOW_ID_NONE</a></td>
          <tr><td><a href="#property-WINDOW_ID_CURRENT">WINDOW_ID_CURRENT</a></td>
        <tr><th colspan="2">Methods</th></tr>
        <tr><td><a href="#method-get">get</a> &minus;
            <code class="prettyprint">
            chrome.windows.get(<span>integer windowId</span>, <span class="optional">object getInfo</span>, <span>function callback</span>)
            </code>
          </td></tr>
        <tr><td><a href="#method-getCurrent">getCurrent</a> &minus;
            <code class="prettyprint">
            chrome.windows.getCurrent(<span class="optional">object getInfo</span>, <span>function callback</span>)
            </code>
          </td></tr>
        <tr><td><a href="#method-getLastFocused">getLastFocused</a> &minus;
            <code class="prettyprint">
            chrome.windows.getLastFocused(<span class="optional">object getInfo</span>, <span>function callback</span>)
            </code>
          </td></tr>
        <tr><td><a href="#method-getAll">getAll</a> &minus;
            <code class="prettyprint">
            chrome.windows.getAll(<span class="optional">object getInfo</span>, <span>function callback</span>)
            </code>
          </td></tr>
        <tr><td><a href="#method-create">create</a> &minus;
            <code class="prettyprint">
            chrome.windows.create(<span class="optional">object createData</span>, <span class="optional">function callback</span>)
            </code>
          </td></tr>
        <tr><td><a href="#method-update">update</a> &minus;
            <code class="prettyprint">
            chrome.windows.update(<span>integer windowId</span>, <span>object updateInfo</span>, <span class="optional">function callback</span>)
            </code>
          </td></tr>
        <tr><td><a href="#method-remove">remove</a> &minus;
            <code class="prettyprint">
            chrome.windows.remove(<span>integer windowId</span>, <span class="optional">function callback</span>)
            </code>
          </td></tr>
        <tr><th colspan="2">Events</th></tr>
          <tr><td><a href="#event-onCreated">onCreated</a></td></tr>
          <tr><td><a href="#event-onRemoved">onRemoved</a></td></tr>
          <tr><td><a href="#event-onFocusChanged">onFocusChanged</a></td></tr>
    </table>
    </section>
    <section>
      <div class="api-reference">
          <h2 id="types">Types</h2>
            <div>
              <h3 id="type-Window">Window</h3>
              <table>
                  <tr><th colspan="3" id="Window-properties">properties</th></tr>
                  <tr id="property-Window-id">
                    <td>integer</td>
                    <td><span class="optional">(optional)</span>
                        id</td>
                    <td>

                      The ID of the window. Window IDs are unique within a browser session. Under some circumstances a Window may not be assigned an ID, for example when querying windows using the <a href=sessions>sessions</a> API, in which case a session ID may be present.
                    </td>
                  </tr><tr id="property-Window-focused">
                    <td>boolean</td>
                    <td>
                        focused</td>
                    <td>

                      Whether the window is currently the focused window.
                    </td>
                  </tr><tr id="property-Window-top">
                    <td>integer</td>
                    <td><span class="optional">(optional)</span>
                        top</td>
                    <td>

                      The offset of the window from the top edge of the screen in pixels. Under some circumstances a Window may not be assigned top property, for example when querying closed windows from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr><tr id="property-Window-left">
                    <td>integer</td>
                    <td><span class="optional">(optional)</span>
                        left</td>
                    <td>

                      The offset of the window from the left edge of the screen in pixels. Under some circumstances a Window may not be assigned left property, for example when querying closed windows from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr><tr id="property-Window-width">
                    <td>integer</td>
                    <td><span class="optional">(optional)</span>
                        width</td>
                    <td>

                      The width of the window, including the frame, in pixels. Under some circumstances a Window may not be assigned width property, for example when querying closed windows from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr><tr id="property-Window-height">
                    <td>integer</td>
                    <td><span class="optional">(optional)</span>
                        height</td>
                    <td>

                      The height of the window, including the frame, in pixels. Under some circumstances a Window may not be assigned height property, for example when querying closed windows from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr><tr id="property-Window-tabs">
                    <td>array of     <a href=tabs#type-Tab>tabs.Tab</a></td>
                    <td><span class="optional">(optional)</span>
                        tabs</td>
                    <td>

                      Array of <a href=tabs#type-Tab>tabs.Tab</a> objects representing the current tabs in the window.
                    </td>
                  </tr><tr id="property-Window-incognito">
                    <td>boolean</td>
                    <td>
                        incognito</td>
                    <td>

                      Whether the window is incognito.
                    </td>
                  </tr><tr id="property-Window-type">
                    <td>enum of <code>"normal"</code>, <code>"popup"</code>, <code>"panel"</code>, or <code>"app"</code></td>
                    <td><span class="optional">(optional)</span>
                        type</td>
                    <td>

                      The type of browser window this is. Under some circumstances a Window may not be assigned type property, for example when querying closed windows from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr><tr id="property-Window-state">
                    <td>enum of <code>"normal"</code>, <code>"minimized"</code>, <code>"maximized"</code>, or <code>"fullscreen"</code></td>
                    <td><span class="optional">(optional)</span>
                        state</td>
                    <td>
                    <span class="availability">Stable since Chrome 17.</span>

                      The state of this browser window. Under some circumstances a Window may not be assigned state property, for example when querying closed windows from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr><tr id="property-Window-alwaysOnTop">
                    <td>boolean</td>
                    <td>
                        alwaysOnTop</td>
                    <td>
                    <span class="availability">Stable since Chrome 19.</span>

                      Whether the window is set to be always on top.
                    </td>
                  </tr><tr id="property-Window-sessionId">
                    <td>string</td>
                    <td><span class="optional">(optional)</span>
                        sessionId</td>
                    <td>
                    <span class="availability">Stable since Chrome 31.</span>

                      The session ID used to uniquely identify a Window obtained from the <a href=sessions>sessions</a> API.
                    </td>
                  </tr>
              </table>
            </div>
          <h2 id="properties">Properties</h2>
          <table>
            <tr>
              <td><span class="type_name">  <code>-1</code></span></td>
              <td><code id="property-WINDOW_ID_NONE">chrome.windows.WINDOW_ID_NONE</code></td>
              <td>
                  The windowId value that represents the absence of a chrome browser window.
              </td>
            </tr>
            <tr>
              <td><span class="type_name">  <code>-2</code></span></td>
              <td><code id="property-WINDOW_ID_CURRENT">chrome.windows.WINDOW_ID_CURRENT</code></td>
              <td>
                  The windowId value that represents the <a href='windows#current-window'>current window</a>.
              </td>
            </tr>
          </table>
          <h2 id="methods">Methods</h2>
            <div>
              <h3
                  id="method-get"
                  >get
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.get(<span>integer windowId</span>, <span class="optional">object getInfo</span>, <span>function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Gets details about a window.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-get-windowId">
                      <td>integer</td>
                      <td>
                          windowId</td>
                      <td>

                      </td>
                    </tr>
                    <tr id="property-get-getInfo">
                      <td>object</td>
                      <td><span class="optional">(optional)</span>
                          getInfo</td>
                      <td>
                      <span class="availability">Stable since Chrome 18.</span>

                        <table class="innerTable">
                          <tr id="property-getInfo-populate">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                populate</td>
                            <td>

                              If true, the <a href=windows#type-Window>windows.Window</a> object will have a <var>tabs</var> property that contains a list of the <a href=tabs#type-Tab>tabs.Tab</a> objects. The <code>Tab</code> objects only contain the <code>url</code>, <code>title</code> and <code>favIconUrl</code> properties if the extension's manifest file includes the <code>"tabs"</code> permission.
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr id="property-get-callback">
                      <td>function</td>
                      <td>
                          callback</td>
                      <td>

                          <p>
                              The <em>callback</em> parameter should be a function
                              that looks like this:
                          </p>
                        <code class="prettyprint">function(    <a href=windows#type-Window>Window</a> window) <span class="subdued">{...}</span>;</code>
                          <table class="innerTable">
                            <tr id="property-callback-window">
                              <td>    <a href=windows#type-Window>Window</a></td>
                              <td>
                                  window</td>
                              <td>

                              </td>
                            </tr>
                          </table>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
            <div>
              <h3
                  id="method-getCurrent"
                  >getCurrent
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.getCurrent(<span class="optional">object getInfo</span>, <span>function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Gets the <a href='#current-window'>current window</a>.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-getCurrent-getInfo">
                      <td>object</td>
                      <td><span class="optional">(optional)</span>
                          getInfo</td>
                      <td>
                      <span class="availability">Stable since Chrome 18.</span>

                        <table class="innerTable">
                          <tr id="property-getInfo-populate">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                populate</td>
                            <td>

                              If true, the <a href=windows#type-Window>windows.Window</a> object will have a <var>tabs</var> property that contains a list of the <a href=tabs#type-Tab>tabs.Tab</a> objects. The <code>Tab</code> objects only contain the <code>url</code>, <code>title</code> and <code>favIconUrl</code> properties if the extension's manifest file includes the <code>"tabs"</code> permission.
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr id="property-getCurrent-callback">
                      <td>function</td>
                      <td>
                          callback</td>
                      <td>

                          <p>
                              The <em>callback</em> parameter should be a function
                              that looks like this:
                          </p>
                        <code class="prettyprint">function(    <a href=windows#type-Window>Window</a> window) <span class="subdued">{...}</span>;</code>
                          <table class="innerTable">
                            <tr id="property-callback-window">
                              <td>    <a href=windows#type-Window>Window</a></td>
                              <td>
                                  window</td>
                              <td>

                              </td>
                            </tr>
                          </table>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
            <div>
              <h3
                  id="method-getLastFocused"
                  >getLastFocused
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.getLastFocused(<span class="optional">object getInfo</span>, <span>function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Gets the window that was most recently focused &mdash; typically the window 'on top'.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-getLastFocused-getInfo">
                      <td>object</td>
                      <td><span class="optional">(optional)</span>
                          getInfo</td>
                      <td>
                      <span class="availability">Stable since Chrome 18.</span>

                        <table class="innerTable">
                          <tr id="property-getInfo-populate">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                populate</td>
                            <td>

                              If true, the <a href=windows#type-Window>windows.Window</a> object will have a <var>tabs</var> property that contains a list of the <a href=tabs#type-Tab>tabs.Tab</a> objects. The <code>Tab</code> objects only contain the <code>url</code>, <code>title</code> and <code>favIconUrl</code> properties if the extension's manifest file includes the <code>"tabs"</code> permission.
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr id="property-getLastFocused-callback">
                      <td>function</td>
                      <td>
                          callback</td>
                      <td>

                          <p>
                              The <em>callback</em> parameter should be a function
                              that looks like this:
                          </p>
                        <code class="prettyprint">function(    <a href=windows#type-Window>Window</a> window) <span class="subdued">{...}</span>;</code>
                          <table class="innerTable">
                            <tr id="property-callback-window">
                              <td>    <a href=windows#type-Window>Window</a></td>
                              <td>
                                  window</td>
                              <td>

                              </td>
                            </tr>
                          </table>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
            <div>
              <h3
                  id="method-getAll"
                  >getAll
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.getAll(<span class="optional">object getInfo</span>, <span>function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Gets all windows.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-getAll-getInfo">
                      <td>object</td>
                      <td><span class="optional">(optional)</span>
                          getInfo</td>
                      <td>

                        <table class="innerTable">
                          <tr id="property-getInfo-populate">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                populate</td>
                            <td>

                              If true, each <a href=windows#type-Window>windows.Window</a> object will have a <var>tabs</var> property that contains a list of the <a href=tabs#type-Tab>tabs.Tab</a> objects for that window. The <code>Tab</code> objects only contain the <code>url</code>, <code>title</code> and <code>favIconUrl</code> properties if the extension's manifest file includes the <code>"tabs"</code> permission.
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr id="property-getAll-callback">
                      <td>function</td>
                      <td>
                          callback</td>
                      <td>

                          <p>
                              The <em>callback</em> parameter should be a function
                              that looks like this:
                          </p>
                        <code class="prettyprint">function(array of     <a href=windows#type-Window>Window</a> windows) <span class="subdued">{...}</span>;</code>
                          <table class="innerTable">
                            <tr id="property-callback-windows">
                              <td>array of     <a href=windows#type-Window>Window</a></td>
                              <td>
                                  windows</td>
                              <td>

                              </td>
                            </tr>
                          </table>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
            <div>
              <h3
                  id="method-create"
                  >create
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.create(<span class="optional">object createData</span>, <span class="optional">function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Creates (opens) a new browser with any optional sizing, position or default URL provided.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-create-createData">
                      <td>object</td>
                      <td><span class="optional">(optional)</span>
                          createData</td>
                      <td>

                        <table class="innerTable">
                          <tr id="property-createData-url">
                            <td>string or array of string</td>
                            <td><span class="optional">(optional)</span>
                                url</td>
                            <td>

                              A URL or array of URLs to open as tabs in the window. Fully-qualified URLs must include a scheme (i.e. 'http://www.google.com', not 'www.google.com'). Relative URLs will be relative to the current page within the extension. Defaults to the New Tab Page.
                            </td>
                          </tr><tr id="property-createData-tabId">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                tabId</td>
                            <td>
                            <span class="availability">Stable since Chrome 10.</span>

                              The id of the tab for which you want to adopt to the new window.
                            </td>
                          </tr><tr id="property-createData-left">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                left</td>
                            <td>

                              The number of pixels to position the new window from the left edge of the screen. If not specified, the new window is offset naturally from the last focused window. This value is ignored for panels.
                            </td>
                          </tr><tr id="property-createData-top">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                top</td>
                            <td>

                              The number of pixels to position the new window from the top edge of the screen. If not specified, the new window is offset naturally from the last focused window. This value is ignored for panels.
                            </td>
                          </tr><tr id="property-createData-width">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                width</td>
                            <td>

                              The width in pixels of the new window, including the frame. If not specified defaults to a natural width.
                            </td>
                          </tr><tr id="property-createData-height">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                height</td>
                            <td>

                              The height in pixels of the new window, including the frame. If not specified defaults to a natural height.
                            </td>
                          </tr><tr id="property-createData-focused">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                focused</td>
                            <td>
                            <span class="availability">Stable since Chrome 12.</span>

                              If true, opens an active window. If false, opens an inactive window.
                            </td>
                          </tr><tr id="property-createData-incognito">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                incognito</td>
                            <td>

                              Whether the new window should be an incognito window.
                            </td>
                          </tr><tr id="property-createData-type">
                            <td>enum of <code>"normal"</code>, <code>"popup"</code>, <code>"panel"</code>, or <code>"detached_panel"</code></td>
                            <td><span class="optional">(optional)</span>
                                type</td>
                            <td>

                              Specifies what type of browser window to create. The 'panel' and 'detached_panel' types create a popup unless the '--enable-panels' flag is set.
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr id="property-create-callback">
                      <td>function</td>
                      <td><span class="optional">(optional)</span>
                          callback</td>
                      <td>

                          <p>
                              If you specify the <em>callback</em> parameter, it should
                              be a function that looks like this:
                          </p>
                        <code class="prettyprint">function(    <a href=windows#type-Window>Window</a> window) <span class="subdued">{...}</span>;</code>
                          <table class="innerTable">
                            <tr id="property-callback-window">
                              <td>    <a href=windows#type-Window>Window</a></td>
                              <td><span class="optional">(optional)</span>
                                  window</td>
                              <td>

                                Contains details about the created window.
                              </td>
                            </tr>
                          </table>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
            <div>
              <h3
                  id="method-update"
                  >update
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.update(<span>integer windowId</span>, <span>object updateInfo</span>, <span class="optional">function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Updates the properties of a window. Specify only the properties that you want to change; unspecified properties will be left unchanged.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-update-windowId">
                      <td>integer</td>
                      <td>
                          windowId</td>
                      <td>

                      </td>
                    </tr>
                    <tr id="property-update-updateInfo">
                      <td>object</td>
                      <td>
                          updateInfo</td>
                      <td>

                        <table class="innerTable">
                          <tr id="property-updateInfo-left">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                left</td>
                            <td>

                              The offset from the left edge of the screen to move the window to in pixels. This value is ignored for panels.
                            </td>
                          </tr><tr id="property-updateInfo-top">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                top</td>
                            <td>

                              The offset from the top edge of the screen to move the window to in pixels. This value is ignored for panels.
                            </td>
                          </tr><tr id="property-updateInfo-width">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                width</td>
                            <td>

                              The width to resize the window to in pixels. This value is ignored for panels.
                            </td>
                          </tr><tr id="property-updateInfo-height">
                            <td>integer</td>
                            <td><span class="optional">(optional)</span>
                                height</td>
                            <td>

                              The height to resize the window to in pixels. This value is ignored for panels.
                            </td>
                          </tr><tr id="property-updateInfo-focused">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                focused</td>
                            <td>
                            <span class="availability">Stable since Chrome 8.</span>

                              If true, brings the window to the front. If false, brings the next window in the z-order to the front.
                            </td>
                          </tr><tr id="property-updateInfo-drawAttention">
                            <td>boolean</td>
                            <td><span class="optional">(optional)</span>
                                drawAttention</td>
                            <td>
                            <span class="availability">Stable since Chrome 14.</span>

                              If true, causes the window to be displayed in a manner that draws the user's attention to the window, without changing the focused window. The effect lasts until the user changes focus to the window. This option has no effect if the window already has focus. Set to false to cancel a previous draw attention request.
                            </td>
                          </tr><tr id="property-updateInfo-state">
                            <td>enum of <code>"normal"</code>, <code>"minimized"</code>, <code>"maximized"</code>, or <code>"fullscreen"</code></td>
                            <td><span class="optional">(optional)</span>
                                state</td>
                            <td>
                            <span class="availability">Stable since Chrome 17.</span>

                              The new state of the window. The 'minimized', 'maximized' and 'fullscreen' states cannot be combined with 'left', 'top', 'width' or 'height'.
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr id="property-update-callback">
                      <td>function</td>
                      <td><span class="optional">(optional)</span>
                          callback</td>
                      <td>

                          <p>
                              If you specify the <em>callback</em> parameter, it should
                              be a function that looks like this:
                          </p>
                        <code class="prettyprint">function(    <a href=windows#type-Window>Window</a> window) <span class="subdued">{...}</span>;</code>
                          <table class="innerTable">
                            <tr id="property-callback-window">
                              <td>    <a href=windows#type-Window>Window</a></td>
                              <td>
                                  window</td>
                              <td>

                              </td>
                            </tr>
                          </table>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
            <div>
              <h3
                  id="method-remove"
                  >remove
              </h3>
              <div class="summary uncapitalize">
              <code class="prettyprint">
              chrome.windows.remove(<span>integer windowId</span>, <span class="optional">function callback</span>)
              </code>
              </div>
              <div class="description">
                <p>
                  Removes (closes) a window, and all the tabs inside it.
                </p>
                <table >
                  <tr><th colspan="3">Parameters</th></tr>
                    <tr id="property-remove-windowId">
                      <td>integer</td>
                      <td>
                          windowId</td>
                      <td>

                      </td>
                    </tr>
                    <tr id="property-remove-callback">
                      <td>function</td>
                      <td><span class="optional">(optional)</span>
                          callback</td>
                      <td>

                          <p>
                              If you specify the <em>callback</em> parameter, it should
                              be a function that looks like this:
                          </p>
                        <code class="prettyprint">function() <span class="subdued">{...}</span>;</code>
                      </td>
                    </tr>
                </table>
              </div>
            </div>
          <h2 id="events">Events</h2>
            <div>
              <h3 id="event-onCreated">onCreated</h3>
              <div class="description">
            <p>
                  Fired when a window is created.
                </p>      <tr><td>
                  <div>
                    <h4
                        title="">addListener
                    </h4>
                    <div class="summary uncapitalize">
                    <code class="prettyprint">
                    chrome.windows.onCreated.addListener(<span>function callback</span>)
                    </code>
                    </div>
                    <div class="description">
                      <table class="innerTable">
                        <tr><th colspan="3">Parameters</th></tr>
                          <tr id="property-onCreated-callback">
                            <td>function</td>
                            <td>
                                callback</td>
                            <td>

                                <p>
                                    The <em>callback</em> parameter should be a function
                                    that looks like this:
                                </p>
                              <code class="prettyprint">function(    <a href=windows#type-Window>Window</a> window) <span class="subdued">{...}</span>;</code>
                                <table class="innerTable">
                                  <tr id="property-onCreated-window">
                                    <td>    <a href=windows#type-Window>Window</a></td>
                                    <td>
                                        window</td>
                                    <td>

                                      Details of the window that was created.
                                    </td>
                                  </tr>
                                </table>
                            </td>
                          </tr>
                      </table>
                    </div>
                  </div>
                  </td></tr>
              </div>
            </div>
            <div>
              <h3 id="event-onRemoved">onRemoved</h3>
              <div class="description">
            <p>
                  Fired when a window is removed (closed).
                </p>      <tr><td>
                  <div>
                    <h4
                        title="">addListener
                    </h4>
                    <div class="summary uncapitalize">
                    <code class="prettyprint">
                    chrome.windows.onRemoved.addListener(<span>function callback</span>)
                    </code>
                    </div>
                    <div class="description">
                      <table class="innerTable">
                        <tr><th colspan="3">Parameters</th></tr>
                          <tr id="property-onRemoved-callback">
                            <td>function</td>
                            <td>
                                callback</td>
                            <td>

                                <p>
                                    The <em>callback</em> parameter should be a function
                                    that looks like this:
                                </p>
                              <code class="prettyprint">function(integer windowId) <span class="subdued">{...}</span>;</code>
                                <table class="innerTable">
                                  <tr id="property-onRemoved-windowId">
                                    <td>integer</td>
                                    <td>
                                        windowId</td>
                                    <td>

                                      ID of the removed window.
                                    </td>
                                  </tr>
                                </table>
                            </td>
                          </tr>
                      </table>
                    </div>
                  </div>
                  </td></tr>
              </div>
            </div>
            <div>
              <h3 id="event-onFocusChanged">onFocusChanged</h3>
              <div class="description">
            <p>
                  Fired when the currently focused window changes. Will be chrome.windows.WINDOW_ID_NONE if all chrome windows have lost focus. Note: On some Linux window managers, WINDOW_ID_NONE will always be sent immediately preceding a switch from one chrome window to another.
                </p>      <tr><td>
                  <div>
                    <h4
                        title="">addListener
                    </h4>
                    <div class="summary uncapitalize">
                    <code class="prettyprint">
                    chrome.windows.onFocusChanged.addListener(<span>function callback</span>)
                    </code>
                    </div>
                    <div class="description">
                      <table class="innerTable">
                        <tr><th colspan="3">Parameters</th></tr>
                          <tr id="property-onFocusChanged-callback">
                            <td>function</td>
                            <td>
                                callback</td>
                            <td>

                                <p>
                                    The <em>callback</em> parameter should be a function
                                    that looks like this:
                                </p>
                              <code class="prettyprint">function(integer windowId) <span class="subdued">{...}</span>;</code>
                                <table class="innerTable">
                                  <tr id="property-onFocusChanged-windowId">
                                    <td>integer</td>
                                    <td>
                                        windowId</td>
                                    <td>

                                      ID of the newly focused window.
                                    </td>
                                  </tr>
                                </table>
                            </td>
                          </tr>
                      </table>
                    </div>
                  </div>
                  </td></tr>
              </div>
            </div>
      </div>
        <h2 id="samples">Sample Extensions</h2>
        <ul>
          <li><strong><a href="samples#cookie-api-test-extension">Cookie API Test Extension</a></strong>
          &ndash; Testing Cookie API
      </li>
          <li><strong><a href="samples#live-http-headers">Live HTTP headers</a></strong>
          &ndash; Displays the live log with the http requests headers
      </li>
          <li><strong><a href="samples#download-selected-links">Download Selected Links</a></strong>
          &ndash; Select links on a page and download them.
      </li>
          <li><strong><a href="samples#keep-awake">Keep Awake</a></strong>
          &ndash; Override system power-saving settings.
      </li>
          <li><strong><a href="samples#show-tabs-in-process">Show Tabs in Process</a></strong>
          &ndash; Adds a browser action showing which tabs share the current tab's process.
      </li>
          <li><strong><a href="samples#tab-inspector">Tab Inspector</a></strong>
          &ndash; Utility for working with the extension tabs api
      </li>
          <li><strong><a href="samples#console-tts-engine">Console TTS Engine</a></strong>
          &ndash; A "silent" TTS engine that prints text to a small window rather than synthesizing speech.
      </li>
          <li><strong><a href="samples#merge-windows">Merge Windows</a></strong>
          &ndash; Merges all of the browser's windows into the current window
      </li>
          <li><strong><a href="samples#chrome-sounds">Chrome Sounds</a></strong>
          &ndash; Enjoy a more magical and immersive experience when browsing the web using the power of sound.
      </li>
          <li><strong><a href="samples#google-mail-checker">Google Mail Checker</a></strong>
          &ndash; Displays the number of unread messages in your Google Mail inbox. You can also click the button to open your inbox.
      </li>
          <li><strong><a href="samples#imageinfo">Imageinfo</a></strong>
          &ndash; Get image info for images, including EXIF data
      </li>
          <li><strong><a href="samples#speak-selection">Speak Selection</a></strong>
          &ndash; Speaks the current selection out loud.
      </li>
        </ul>
    </section>
  </div>
</article>
    </main>

    <footer id="gc-footer" role="contentinfo" class="span-full">
      <div class="g-section g-tpl-50-50">
        <div class="g-unit g-first">
          <nav class="links">
            <a href="https://www.google.com/">Google</a><a href="https://developers.google.com/site-terms">Terms of Service</a><a href="http://www.google.com/intl/en/privacy/">Privacy Policy</a><a href="" data-feedback>Report a bug</a>
          </nav>
        </div>
        <div class="g-unit g-last">
          <div id="social-buttons">
            <div data-size="small" data-href="http://www.google.com/chrome" data-annotation="bubble" class="g-plusone"></div>
            <a rel="publisher" target="_blank" href="https://plus.google.com/+GoogleChromeDevelopers?prsrc=3" data-g-label="plus" data-g-event="nav-subfooter">Add us on <span class="element-invisible">Google+</span><img src="//ssl.gstatic.com/images/icons/gplus-16.png" data-g-label="plus" data-g-event="nav-subfooter" alt=""></a>
          </div>
        </div>
      </div>
    </footer>

  </div>

    <script src="/static/js/fatnav.js"></script>
    <script src="/static/js/article.js"></script>
    <script src="/static/js/prettify.js"></script>
    <script src="/static/js/search.js"></script>
    <script src="//www.gstatic.com/feedback/api.js"></script>
    <script src="/static/js/site.js"></script>
  </body>
</html>
"""
exports.fixLinks(html, the_url)

