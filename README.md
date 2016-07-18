# RestFire

A REST client wrapper around [Alamofire](https://github.com/Alamofire/Alamofire).
It also takes advantage of [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).

Supported methods so far:
- `GET`
- `POST`
- `PUT`
- `PATCH`
- `DELETE`

##### Initiate the RestFire client

  ``` Swift
    import RestFire
  
    // Initiate the RestFire client
    let restFire = RestFire(baseUrl: "https://some.website.com/api")
  ```

##### Get a resource from the server
  ``` Swift
    restFire["comments"].get().response {
      value, error in
      
      if let error = error {
        return print("Error fetching comments: \(error)")
      }
      
      if let value = value {
        
        let firstComment = value[0]
        print(firstComment["author"])
      }
    }
  ```
  
##### Post a resource to the server
  ``` Swift
  let newComment = ["author": "John Doe", "message": "This is really cool!"]
  
    restFire["comments"].post(newComment).response {
      value, error in
      
      if let error = error {
        return print("Error posting comment: \(error)")
      }
      
      if let value = value {
        
        print(value)
      }
    }
  ```
#### Get a resource through a relationship

``` Swift
  restFire["posts"][3]["comments"].get().response {
    value, error in
    
    print(error)
    
    print(value)
  }
```
  
#### Server response object
The `value` variable in the response closure is of type JSON, this type comes from SwiftyJSON.

The `error` variable is of type NSError. This may contain a 'reason' within the 'userInfo' dictionary.
  
#### Integration
##### CocoaPods
You can use [CocoaPods](https://cocoapods.org/) to install RestFire by adding it to your Podfile:
``` Ruby
  source 'git@github.com:OlafAndreas/RestFire.git'

  platform :ios, '9.0'
  use_frameworks!

  target 'MyApp' do
    pod 'RestFire'
  end
```
