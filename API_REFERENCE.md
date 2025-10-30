# API Reference - Mobile App For Shops

Quick reference for services, models, and providers.

## Models

### User Model

```dart
User(
  id: String,
  email: String,
  displayName: String,
  createdAt: DateTime,
  updatedAt: DateTime,
  profilePictureUrl: String?,
  isEmailVerified: bool,
  phoneNumber: String?,
  shopIds: List<String>,
)
```

### Shop Model

```dart
Shop(
  id: String,
  name: String,
  ownerId: String,
  address: String,
  city: String?,
  state: String?,
  postalCode: String?,
  phone: String?,
  email: String?,
  website: String?,
  isActive: bool,
  createdAt: DateTime,
  updatedAt: DateTime,
)
```

### Item Model

```dart
Item(
  id: String,
  name: String,
  description: String?,
  price: double,
  quantity: int,
  shopId: String,
  category: String?,
  sku: String?,
  isActive: bool,
  createdAt: DateTime,
  updatedAt: DateTime,
)
```

### Order Model

```dart
Order(
  id: String,
  shopId: String,
  userId: String,
  items: List<OrderItem>,
  totalAmount: double,
  status: OrderStatus, // pending, confirmed, processing, shipped, delivered, cancelled
  notes: String?,
  customerName: String?,
  customerEmail: String?,
  customerPhone: String?,
  deliveryAddress: String?,
  createdAt: DateTime,
  updatedAt: DateTime,
)
```

## Services

### AuthService

```dart
// Sign up
Future<User> signUp({
  required String email,
  required String password,
})

// Login
Future<User> login({
  required String email,
  required String password,
})

// Logout
Future<void> logout()

// Reset password
Future<void> resetPassword(String email)

// Get current user
Future<User?> getCurrentUser()

// Check if authenticated
bool get isAuthenticated

// Get auth state stream
Stream<User?> get authStateChanges()
```

### FirestoreService

```dart
// Create document
Future<void> createDocument({
  required String collectionName,
  required String docId,
  required Map<String, dynamic> data,
})

// Get document
Future<Map<String, dynamic>?> getDocument({
  required String collectionName,
  required String docId,
})

// Update document
Future<void> updateDocument({
  required String collectionName,
  required String docId,
  required Map<String, dynamic> data,
})

// Delete document
Future<void> deleteDocument({
  required String collectionName,
  required String docId,
})

// Query collection
Future<List<Map<String, dynamic>>> queryCollection({
  required String collectionName,
  int limit = 100,
})

// Stream collection
Stream<List<Map<String, dynamic>>> streamCollection(String collectionName)

// Stream document
Stream<Map<String, dynamic>?> streamDocument({
  required String collectionName,
  required String docId,
})

// Batch write
Future<void> batchWrite({
  required String collectionName,
  required List<Map<String, dynamic>> documents,
})
```

### SQLiteService

```dart
// Initialize
Future<void> initialize()

// Insert
Future<int> insert({
  required String table,
  required Map<String, dynamic> data,
})

// Query
Future<List<Map<String, dynamic>>> query({
  required String table,
  String? where,
  List<dynamic>? whereArgs,
  String? orderBy,
  int? limit,
})

// Get by ID
Future<Map<String, dynamic>?> getById({
  required String table,
  required String id,
})

// Update
Future<int> update({
  required String table,
  required Map<String, dynamic> data,
  required String where,
  List<dynamic>? whereArgs,
})

// Delete
Future<int> delete({
  required String table,
  String? where,
  List<dynamic>? whereArgs,
})

// Transaction
Future<void> transaction(Future<void> Function(Transaction txn) action)

// Close
Future<void> close()
```

### ConnectivityService

```dart
// Check if online
Future<bool> isOnline()

// Get connectivity stream
Stream<bool> get connectionStatusStream

// Check WiFi
Future<bool> isWifiConnected()

// Check mobile data
Future<bool> isMobileConnected()
```

### SyncService

```dart
// Synchronize
Future<void> synchronize()

// Queue operation
Future<void> queueOperation({
  required String operation,
  required String collectionName,
  required String documentId,
  required Map<String, dynamic> data,
})

// Get pending operations
Future<List<Map<String, dynamic>>> getPendingOperations()

// Clear completed
Future<void> clearCompletedOperations()

// Update last sync time
Future<void> updateLastSyncTime(String collectionName)

// Get last sync time
Future<DateTime?> getLastSyncTime(String collectionName)

// Get is syncing
bool get isSyncing

// Get pending count
Future<int> getPendingOperationCount()
```

## Providers

### AuthProvider

```dart
// Methods
Future<void> signUp({required String email, required String password})
Future<void> login({required String email, required String password})
Future<void> logout()
Future<void> resetPassword(String email)
void clearError()

// Getters
User? get currentUser
bool get isLoading
String? get errorMessage
bool get isAuthenticated
String get userEmail
String get userName
```

### ConnectivityProvider

```dart
// Getters
bool get isOnline
bool get isOffline
String get statusMessage
```

### DataProvider

```dart
// Shop operations
Future<void> loadShops({required String userId})
Future<void> createShop({...})
Future<void> updateShop(Shop shop)
Future<void> deleteShop(String shopId)

// Item operations
Future<void> loadItems({required String shopId})
Future<void> createItem({...})
Future<void> updateItem(Item item)
Future<void> deleteItem(String itemId)

// Order operations
Future<void> loadOrders({required String shopId})
Future<void> createOrder(Order order)
Future<void> updateOrderStatus(String orderId, OrderStatus status)

// Other
void setSelectedShop(Shop? shop)
void clearError()

// Getters
List<Shop> get shops
List<Item> get items
List<Order> get orders
Shop? get selectedShop
bool get isLoading
String? get error
```

### SyncProvider

```dart
// Methods
Future<void> triggerSync()

// Getters
bool get isSyncing
DateTime? get lastSyncTime
int get pendingOperationCount
String get lastSyncMessage
```

## Validators

```dart
// Email validation
String? validateEmail(String? value)

// Password validation
String? validatePassword(String? value)

// Password confirmation
String? validatePasswordConfirmation(String? value, String? password)

// Required field
String? validateRequired(String? value, String fieldName)

// Min length
String? validateMinLength(String? value, int minLength)

// Max length
String? validateMaxLength(String? value, int maxLength)

// Phone number
String? validatePhone(String? value)

// URL
String? validateUrl(String? value)

// Check if numeric
bool isNumeric(String? value)

// Check if alphabetic
bool isAlphabetic(String? value)

// Check if alphanumeric
bool isAlphanumeric(String? value)
```

## Extensions

### String Extensions

```dart
bool get isEmpty
bool get isNotEmpty
String get capitalized
String get titleCase
String get removeWhitespace
bool get isValidEmail
bool get isValidUrl
String truncate(int maxLength, {String ellipsis = '...'})
```

### DateTime Extensions

```dart
String get formattedDate        // yyyy-MM-dd
String get formattedTime        // HH:mm:ss
String get formattedDateTime    // yyyy-MM-dd HH:mm:ss
String get relativeTime         // "2 hours ago"
bool get isToday
bool get isYesterday
DateTime get dateOnly
DateTime addDays(int days)
DateTime subtractDays(int days)
```

### List Extensions

```dart
bool get isEmpty
bool get isNotEmpty
T? get firstOrNull
T? get lastOrNull
List<T> get unique
List<List<T>> chunk(int size)
```

## Constants

### Colors

```dart
AppConstants.primaryColor           // #2563EB
AppConstants.primaryDarkColor       // #1E40AF
AppConstants.primaryLightColor      // #DECBF5
AppConstants.accentColor            // #10B981
AppConstants.accentDarkColor        // #047857
AppConstants.backgroundColor        // #F9FAFB
AppConstants.surfaceColor           // #FFFFFF
AppConstants.errorColor             // #EF4444
AppConstants.warningColor           // #F59E0B
AppConstants.successColor           // #10B981
AppConstants.infoColor              // #3B82F6
```

### Collections & Tables

```dart
AppConstants.usersCollection        // "users"
AppConstants.shopsCollection        // "shops"
AppConstants.itemsCollection        // "items"
AppConstants.ordersCollection       // "orders"

AppConstants.usersLocalTable        // "users_local"
AppConstants.shopsLocalTable        // "shops_local"
AppConstants.itemsLocalTable        // "items_local"
AppConstants.syncQueueTable         // "sync_queue"
AppConstants.syncMetadataTable      // "sync_metadata"
```

## Routes

```dart
Routes.splash       // "/"
Routes.login        // "/login"
Routes.signup       // "/signup"
Routes.home         // "/home"
Routes.settings     // "/settings"
"/profile"          // Profile screen
"/shops"            // Shops list screen
"/inventory"        // Inventory screen
"/orders"           // Orders screen
"/shop-detail"      // Shop detail screen
```

## Error Handling

### Exception Classes

```dart
// Auth
AuthException
InvalidCredentialsException
UserNotFoundException
UserAlreadyExistsException
WeakPasswordException
SessionExpiredException

// Database
DatabaseException
SQLiteException
FirestoreException
DataNotFoundException
DatabaseInitializationException
DataConflictException

// Sync
SyncException
SyncConflictException
SyncQueueException
SyncNetworkException
SyncTimeoutException
```

## Usage Examples

### Sign Up

```dart
final authProvider = context.read<AuthProvider>();
await authProvider.signUp(
  email: 'user@example.com',
  password: 'SecurePass123',
);
```

### Create Shop

```dart
final dataProvider = context.read<DataProvider>();
await dataProvider.createShop(
  id: const Uuid().v4(),
  name: 'My Shop',
  ownerId: userId,
  address: '123 Main St',
  city: 'Springfield',
);
```

### Add Product

```dart
final dataProvider = context.read<DataProvider>();
await dataProvider.createItem(
  id: const Uuid().v4(),
  name: 'Widget',
  price: 29.99,
  quantity: 100,
  shopId: shopId,
  description: 'A useful widget',
);
```

### Listen to Connectivity

```dart
context.watch<ConnectivityProvider>().isOnline
```

### Manual Sync

```dart
final syncProvider = context.read<SyncProvider>();
await syncProvider.triggerSync();
```

## Performance Tips

1. Use `Consumer` for selective rebuilds
2. Cache data in providers
3. Limit Firestore queries with `limit()`
4. Use batch operations for multiple writes
5. Monitor sync status before critical operations

## Security

- All data encrypted in transit (Firebase)
- Local SQLite not encrypted (implement if needed)
- Firestore rules must be updated for production
- Sensitive data never logged
- Authentication via Firebase Auth

## Testing

```dart
// Mock service
final mockAuthService = MockAuthService();

// Test provider
final authProvider = AuthProvider(authService: mockAuthService);

// Use in tests
expect(authProvider.isLoading, false);
```
