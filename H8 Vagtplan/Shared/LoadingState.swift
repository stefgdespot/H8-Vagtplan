import Foundation

enum LoadingState<T> {
    case loading
    case loaded(T)
    case failed(String)
}
