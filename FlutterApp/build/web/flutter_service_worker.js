'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f1bca0088196ce43886a51e6428a2e00",
"assets/AssetManifest.bin.json": "4352101ff802c478d2c180dc6240dfb6",
"assets/AssetManifest.json": "ef5e142de22e31038c822e2f16e097ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "dcff3d98ef2b1f85cdcaa56babc92b42",
"assets/lib/Assets/icons/air-conditioner.png": "1d61570b847597aa7e4b75ab00a85850",
"assets/lib/Assets/icons/app_icon.png": "81e7eba98bbaf4d716ce5c581bf71bc5",
"assets/lib/Assets/icons/co2.png": "bdf886bee40c2a75ed3f2b85ec0aa4aa",
"assets/lib/Assets/icons/fan.png": "beabdec54642d48ff8bf13dbfa093e37",
"assets/lib/Assets/icons/humidity.png": "d634e4a6801e91e2e5ff3d97190dc671",
"assets/lib/Assets/icons/light-bulb.png": "51667a8a651e95b3ce951da144b152fc",
"assets/lib/Assets/icons/Logo-DH-Bach-Khoa-HCMUT.png": "d84d339e9c398272fccaf975569a6eed",
"assets/lib/Assets/icons/menu.png": "80f3e22ecf31daafd2f33d2c75743b9c",
"assets/lib/Assets/icons/pm10.png": "b0f91105ed549bd9551985805ddb010b",
"assets/lib/Assets/icons/pm1_0.png": "3797d963f61fb9ef5a360a82d53047c4",
"assets/lib/Assets/icons/pm25.png": "8d57e34215ffcb14d4d7ed9069d31df7",
"assets/lib/Assets/icons/pm40.png": "d64ba9646294da66d7f9e761181ecf00",
"assets/lib/Assets/icons/smart-tv.png": "c4ed5129d15b0115618982814c92d1ad",
"assets/lib/Assets/icons/temperature.png": "7a33f5871fffbe5c823dadaefa23bec1",
"assets/NOTICES": "d4e7e97e333705f9a3e0c72a7f57c0de",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "5fda3f1af7d6433d53b24083e2219fa0",
"canvaskit/canvaskit.js.symbols": "0c3f8ba3bd6d389de47ac4ba771c9dc6",
"canvaskit/canvaskit.wasm": "4a16f90aba0792bf567e688033c56416",
"canvaskit/chromium/canvaskit.js": "87325e67bf77a9b483250e1fb1b54677",
"canvaskit/chromium/canvaskit.js.symbols": "ee5f10fe667aefb01c922f90f7b84ac6",
"canvaskit/chromium/canvaskit.wasm": "986840fed36860995818f25544f7f9a0",
"canvaskit/skwasm.js": "f17a293d422e2c0b3a04962e68236cc2",
"canvaskit/skwasm.js.symbols": "4142410438d40ea77420b7d9df1f0501",
"canvaskit/skwasm.wasm": "619af4426955adf484c6ff17d71e0ad9",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "04dc529aa2f0b74ed320917a90d398f0",
"flutter.js": "f31737fb005cd3a3c6bd9355efd33061",
"flutter_bootstrap.js": "6394bccd6f69e91f7703f33e3dbb2f6d",
"icons/Icon-192.png": "bbd85884acd58c216799394fb5a29709",
"icons/Icon-512.png": "6650f4597695e92b41f0ce21c5148b41",
"icons/Icon-maskable-192.png": "bbd85884acd58c216799394fb5a29709",
"icons/Icon-maskable-512.png": "6650f4597695e92b41f0ce21c5148b41",
"index.html": "49b86b413e97cdec6445953d84d318fe",
"/": "49b86b413e97cdec6445953d84d318fe",
"main.dart.js": "7a2426b632434d3895669c4de9db6f73",
"manifest.json": "b39938db0c5f0866970edb1748d6c695",
"version.json": "322dfa94430cc69aa45ce83495f46466"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
