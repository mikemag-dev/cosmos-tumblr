# Cosmos Tumblr

## Description
Cosmos Tumble is an app which displays a scrollabe grid of images loaded from a (for now) hardcoded blog. Original images can be viewed in a detail screen. Pinch or zoom to change grid size. Note it is experimental beyond 5 columns 😅

## Structure

### Architecture
MVVM
- `Response` folder contains raw-form data, effectively a parsed mirror of would-be server data.
- `Request` folder contains structs representing requests needed for networking.
- `Tumblr/` is the service specific to data fetched from Tumblr. TumblrClient accepts a `Request` object and prepares the fetch which is sent to the `NetworkClient`'s generic `fetch` network call.
- `ViewModel` folder contains view models which are intialized from `Model`s. ViewModels, where applicable, can be injected with a `DataProvider` for testing and simulation.
- `Views` folder contains views. Views, currently, contain a single view model which prepares data for display. When possible for local view state, the state is managed by the view.

### Dependency Injection
Project makes use of point-free's [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) for Dependency Injection. At a glance, the library enables dependencies to be accessed via a `@Dependency` property wrapper. Dependencies can then be accessed anywhere using similar syntax to the `@Environment` property wrapper available in `View` contexts. The framework enables configuration of a `previewValue` used for SwiftUI Previews and a `liveValue` used for runtime. The framework is also a forcing function for how a dependency should look. It suggests, rather than a protocol, a struct with closures is used which provides similar effect. This approach provides less brittleness for changes e.g. when modifying a protocol, all conforming classes must reflect those changes. Using the struct/closure approach enables easier default implementations.

DI is currently used for the Router and Tumblr services.

### Pagination
The Paginator class is a generic class intended to support pagination for different requests conforming to `PageableResponse` protocol. It exposed a stream of data which is updated as pagination fetches are made. Overengineered for the scope of the project, but demonstrates how it might be useful in future pagination contexts.

### Data Provisioning (Handrolled, Deprecated)
Before point-free's [swift-dependencies](https://github.com/pointfreeco/swift-dependencies) was integrated, there was a handrolled DI-supported approach to networking data providers. Data is created locally and randomly via `TumblrDataProviderMock` which implements a `TumblrDataProvidable` protocol. Data is can also be fetched live using `TumblrDataProvider` which similarly implements the `TumblrDataProvidable` protocol. `TumblrDataProvidable` provides an interface so that mock providers and live providers can be swapped out interchangeably, i.e. dependency injection. Once swift-dependencies was introduced, the injection points for the handrolled approach were removed and the handrolled files were deintegrated.

### Image Caching
Project makes use of Kingfisher for image loading, caching, and prefetching. There is commented code which can be commented in to remove this dependency, however gifs, caching, and prefetching are not supported with AsyncImage out of the box. This would have to be handrolled.

### Routing
The Router dependencies manages a published `path` array of `Destination`. `Destination` is an associated value enumeration which can be mapped to a `View`. For now, path is directly manipulated by the routing context, but as the app might scale, there should be a more proper set of APIs to manipulate and manage `path`.

### General Flow
- `PhotoGridView` appears, sends `Event` to `PhotoGridViewModel`
- `PhotoGridViewModel` receives event, does relevant paging of photos
- `PhotoGridView` renders new state of `PhotoGridViewModel`'s published properties
- `PhotoGridView` scrolls to bottom (or near bottom), sends `Event` to `PhotoGridViewModel`
- `PhotoGridViewModel` receives event, does relevant paging of photos
- `PhotoGridView` renders new state of `PhotoGridViewModel`'s published properties

- `PhotoView` asks for proper thumbnail image from `PhotoViewModel` given `PhotoView`s size
- when `PhotoView` scrolls in to the `PhotoGridView` context, `PhotoViewModel` receives an `Event` indicate it should prefetch
- when `PhotoView` scroless out of the `PhotoGridView` context, `PhotoViewModel` receives an `Event` indicate it should cancel prefetch

### Testing
The current set of tests are not comprehensive, but demonstrate the following:
1. how parsing response objects might be tested so that if changes are made to the response models, decoding strategy, etc, existing code does not break
2. testing inner logic of view models
3. testing the view model state machine (TODO)

## Callouts/Next Steps
- Move dependencies to Package.swift file or integrate alternate packaged dependency manager (I have had a good experience with Tuist, for example)
- Extract frameworks for Features, Networking, Routing, etc. Begin the dependency graph.
- If we want to support grids with many columns, we might need need to be smarter with prefetching.
- Secrets would be in the .gitignore for the actual repo, but committed for sharing purposes
- create API for `Router` to support push/present and other presentation methods
- make scroll detection more robust, currently happening in two places
- memory management, can probably clear prefetched images from cache when scrolled out

## Installation
Dependencies are all Swift Packages contained within the pbxproj file

To start the project, open the `Cosmos.xcodeproj` file and run