<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

Janus is a quick serializer for local storage of data models. Perfect for storing your app preferences or other data of interest. By default, the storage is made with encryption.

## Getting started

Using this package is pretty straightforward. The following examples will store some preferences in memory:

```dart
    class Preferences extends Janus {
     
        const Preferences(
            {this.token = '', 
            this.lightTheme = true, 
            this.fontSize = 15.0,
            this.firstLoading = true,
            this.shoppingCartProducts = const []})
             : super({cypher: true});
    }

        final String token;
        final bool lightTheme;
        final double fontSize;
        final bool firstLoading;
        final List<String> shoppingCartProducts = [];

        Map<String,dynamic> toMap() => {
            'token': token,
            'lightTeme': lightTheme,
            'fontSize': fontSize,
            'firstLoading': firstLoading,
            'shoopingCartProducts': shoppingCartProducts
        };

        factory Preferences.fromMap(Map<String,dynamic> map) 
            => Preferences(
                token: map['token'],
                lightTheme: map['lightTheme'],
                fontSize: map['fontSize'],
                firstLoading: map['firstLoading'],
                shoppingCartProducts: map['shoppingCartProducts']
            );
    
    void main()async{
        final preferences = Preferences();
        final data = {
            'token': 'TOKEN',
            'lightTeme': false,
            'fontSize': 22.2,
            'firstLoading': false,
            'shoopingCartProducts': ['Uuid1','Uuid2','Uuid3']
        }

        await preferences.save(data);
        final loadedPreferences = Preferences.fromMap(await preferences.load());
    }

```

## Usage

Personally, it's preferable not to extend directly Janus to your data model. Instead of that, try to split you data layer in three parts:
* models
* apis
* repositories

The apis folder will bear the classes that will provide access to your webservices or local storage. Here will may be the classes that can extends Janus.

```dart
//apis/user_model.dart
class User{
    final String id;
    final String email;

    Map<String,dynamic> toMap() => {
        'id': id,
        'email': email
    };

    factory User.fromMap(Map<String,dynamic> map) => User(id: map['id'], email: map['email']);
}

//apis/user_storage.dart
class UserStorage extends Janus{
    const UserStorage() : super({cypher:true});
    //janus will provide the load and save methods!

    //obviusly, you can register any needed method here
}

//repositories/user_storage_repository.dart
class UserStorageRepository{

    final api = UserStorage();

    //this is only an example
    Future<void> save(User user)async{
        await api.save(user.toMap());
    }
    Future<User> load() async {
        return await User.fromMap(await api.load());
    }

}

//Now you can use the repository to persist the user in you local memory or to load it from local.
final userRepository = UserStorageRepository();
final User user = User(id: 'uuid', email: 'myemail@address.com');
await userRepository.save(user);

final loadedUser = await userRepository.load();
```

## Additional information


