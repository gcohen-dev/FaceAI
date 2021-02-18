//
// facenet_keras_weights_coreml.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13.2, iOS 11.2, tvOS 11.2, watchOS 4.2, *)
class facenet_keras_weights_coremlInput : MLFeatureProvider {

    /// image as color (kCVPixelFormatType_32BGRA) image buffer, 160 pixels wide by 160 pixels high
    var image: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    init(image: CVPixelBuffer) {
        self.image = image
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageWith image: CGImage) throws {
        let __image = try MLFeatureValue(cgImage: image, pixelsWide: 160, pixelsHigh: 160, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
        self.init(image: __image)
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imageAt image: URL) throws {
        let __image = try MLFeatureValue(imageAt: image, pixelsWide: 160, pixelsHigh: 160, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
        self.init(image: __image)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 160, pixelsHigh: 160, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 160, pixelsHigh: 160, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }
}


/// Model Prediction Output Type
@available(macOS 10.13.2, iOS 11.2, tvOS 11.2, watchOS 4.2, *)
class facenet_keras_weights_coremlOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// output as 128 element vector of doubles
    lazy var output: MLMultiArray = {
        [unowned self] in return self.provider.featureValue(for: "output")!.multiArrayValue
    }()!

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(output: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["output" : MLFeatureValue(multiArray: output)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13.2, iOS 11.2, tvOS 11.2, watchOS 4.2, *)
class facenet_keras_weights_coreml {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "facenet_keras_weights_coreml", withExtension:"mlmodelc")!
    }

    /**
        Construct facenet_keras_weights_coreml instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of facenet_keras_weights_coreml.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `facenet_keras_weights_coreml.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct facenet_keras_weights_coreml instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct facenet_keras_weights_coreml instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct facenet_keras_weights_coreml instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<facenet_keras_weights_coreml, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct facenet_keras_weights_coreml instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<facenet_keras_weights_coreml, Error>) -> Void) {
        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
            if let error = error {
                handler(.failure(error))
            } else if let model = model {
                handler(.success(facenet_keras_weights_coreml(model: model)))
            } else {
                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
            }
        }
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as facenet_keras_weights_coremlInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as facenet_keras_weights_coremlOutput
    */
    func prediction(input: facenet_keras_weights_coremlInput) throws -> facenet_keras_weights_coremlOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as facenet_keras_weights_coremlInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as facenet_keras_weights_coremlOutput
    */
    func prediction(input: facenet_keras_weights_coremlInput, options: MLPredictionOptions) throws -> facenet_keras_weights_coremlOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return facenet_keras_weights_coremlOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - image as color (kCVPixelFormatType_32BGRA) image buffer, 160 pixels wide by 160 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as facenet_keras_weights_coremlOutput
    */
    func prediction(image: CVPixelBuffer) throws -> facenet_keras_weights_coremlOutput {
        let input_ = facenet_keras_weights_coremlInput(image: image)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [facenet_keras_weights_coremlInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [facenet_keras_weights_coremlOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [facenet_keras_weights_coremlInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [facenet_keras_weights_coremlOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [facenet_keras_weights_coremlOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  facenet_keras_weights_coremlOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
