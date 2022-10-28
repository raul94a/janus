

Janus provide an easy API to persist models in the local storage with encryption.

CAPTION: Not working in Flutter Web

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
             : super(cypher: true);
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

class User {
  final String id;
  final String name;
  final String email;
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']  ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );

//apis/user_storage.dart

class UserStorage extends Janus{
  UserStorage() : super(cypher: true);

  
}

//repositories/user_storage_repository.dart
class UserRepo {
  final api = UserStorage();

  Future<void> save(User user)async{
    await api.save(user.toMap());
    
  }

  Future<User> load() async{
    return User.fromMap(await api.load());
  }
}

//Now you can use the repository to persist the user in you local memory or to load it from local.
final userRepository = UserRepo();
final User user = User(id: 'uuid', name:'name',email: 'myemail@address.com');
await userRepository.save(user);

final loadedUser = await userRepository.load();
```

## Additional information


