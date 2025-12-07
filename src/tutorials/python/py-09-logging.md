# Python Logging - Complete Guide

## Why Use Logging?

Logging is essential for:
- **Debugging**: Track what your application is doing
- **Monitoring**: Detect issues in production
- **Audit trails**: Record important events
- **Performance**: Identify bottlenecks

```python
# ❌ Don't use print() in production
print("User logged in")  # Lost after console closes
print(f"Error: {error}")  # No timestamps, no levels

# ✅ Use logging instead
import logging
logging.info("User logged in")  # Saved to file, has timestamp
logging.error(f"Error: {error}")  # Can be filtered by severity
```

---

## Logging Basics

### Log Levels (Severity)

| Level | Value | Usage | Example |
|-------|-------|-------|---------|
| **DEBUG** | 10 | Detailed diagnostic info | `"Variable x = 42"` |
| **INFO** | 20 | General informational messages | `"Server started on port 8000"` |
| **WARNING** | 30 | Warning messages (still works) | `"Disk space low: 5% remaining"` |
| **ERROR** | 40 | Error messages (something failed) | `"Failed to connect to database"` |
| **CRITICAL** | 50 | Critical errors (app may crash) | `"Out of memory, shutting down"` |

### Simple Logging Example

```python
import logging

# Configure logging
logging.basicConfig(
    level=logging.DEBUG,
    format='[%(asctime)s] %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

# Use different log levels
logging.debug('This is a debug message')
logging.info('This is an info message')
logging.warning('This is a warning message')
logging.error('This is an error message')
logging.critical('This is a critical message')

# Output:
# [2024-01-15 10:30:45] DEBUG - This is a debug message
# [2024-01-15 10:30:45] INFO - This is an info message
# [2024-01-15 10:30:45] WARNING - This is a warning message
# [2024-01-15 10:30:45] ERROR - This is an error message
# [2024-01-15 10:30:45] CRITICAL - This is a critical message
```

### Logging with Variables

```python
import logging

logging.basicConfig(level=logging.DEBUG)

# Old style (still works)
user_id = 123
logging.info('User %s logged in', user_id)

# .format() style
logging.debug('Processing order {}'.format(order_id))

# f-string style (Python 3.6+)
name = "Alice"
age = 30
logging.info(f'User {name} is {age} years old')

# Logging objects
class User:
    def __init__(self, id, name):
        self.id = id
        self.name = name

user = User(1, "Alice")
logging.debug('User object: {}'.format(user.id))
logging.info(f'Processing user: {user.name} (ID: {user.id})')
```

---

## Advanced Logging Setup

### Custom Logger Class

Here's a production-ready logging setup based on your example:

```python
# logger_config.py
import logging
import sys
from typing import Optional

# Default configuration
DEFAULT_LOG_LEVEL = 'DEBUG'
DEFAULT_LOG_FORMATTER = '[%(asctime)s] | [%(process)d:%(thread)d] | ' \
                        '[%(levelname)s] | %(module)s.%(name)s | %(message)s'


class LoggerSettings:
    """Configuration for logger settings"""
    def __init__(self, level: str = DEFAULT_LOG_LEVEL, 
                 formatter: str = DEFAULT_LOG_FORMATTER):
        self.level = level
        self.formatter = formatter


class LessThanFilter(logging.Filter):
    """Filter to only allow log records below a certain level"""
    def __init__(self, exclusive_maximum, name=""):
        super(LessThanFilter, self).__init__(name)
        self.max_level = exclusive_maximum

    def filter(self, record):
        # Non-zero return means we log this message
        # Only log if level is LESS than maximum
        return 1 if record.levelno < self.max_level else 0


class MoreOrEqFilter(logging.Filter):
    """Filter to only allow log records at or above a certain level"""
    def __init__(self, exclusive_minimum, name=""):
        super(MoreOrEqFilter, self).__init__(name)
        self.min_level = exclusive_minimum

    def filter(self, record):
        # Non-zero return means we log this message
        # Only log if level is GREATER THAN OR EQUAL to minimum
        return 1 if record.levelno >= self.min_level else 0


def get_logger_instance(
        instance_name: str,
        log_level: str = DEFAULT_LOG_LEVEL,
        log_formatter: str = DEFAULT_LOG_FORMATTER) -> logging.Logger:
    """
    Create a logger instance with custom configuration.
    
    Args:
        instance_name: Name of the logger instance
        log_level: Log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
        log_formatter: Format string for log messages
        
    Returns:
        Configured logger instance
    """
    # Initialize logger
    logger = logging.getLogger(instance_name)
    logger.setLevel(log_level)

    # Clear existing handlers to avoid duplicates
    if logger.hasHandlers():
        logger.handlers.clear()
    
    # Don't propagate to parent loggers
    logger.propagate = False

    # stdout handler (for DEBUG and INFO)
    logging_handler_out = logging.StreamHandler(sys.stdout)
    logging_handler_out.setLevel(log_level)
    logging_handler_out.addFilter(LessThanFilter(logging.WARNING))
    logging_handler_out.setFormatter(logging.Formatter(log_formatter))
    logger.addHandler(logging_handler_out)

    # stderr handler (for WARNING, ERROR, and CRITICAL)
    logging_handler_err = logging.StreamHandler(sys.stderr)
    logging_handler_err.setLevel(logging.WARNING)
    logging_handler_err.addFilter(MoreOrEqFilter(logging.WARNING))
    logging_handler_err.setFormatter(logging.Formatter(log_formatter))
    logger.addHandler(logging_handler_err)

    return logger


def get_logger(
        instance_name: str,
        settings: Optional[LoggerSettings] = None) -> logging.Logger:
    """
    Get a logger with optional custom settings.
    
    Args:
        instance_name: Name of the logger
        settings: Optional LoggerSettings object
        
    Returns:
        Configured logger instance
    """
    if settings:
        return get_logger_instance(
            instance_name,
            settings.level,
            settings.formatter
        )
    else:
        return get_logger_instance(instance_name)
```

### Usage in Your Application

```python
# app.py
from logger_config import get_logger, LoggerSettings

class DataProcessor:
    def __init__(self, name: str):
        # Create logger instance for this class
        self.__log = get_logger(f'DataProcessor.{name}')
        self.name = name
    
    def process_data(self, data_id: int):
        """Process data with comprehensive logging"""
        # DEBUG - Detailed diagnostic information
        self.__log.debug('Starting to process data {}'.format(data_id))
        self.__log.debug(f'Processor name: {self.name}')
        
        try:
            # Simulate processing
            result = self._do_processing(data_id)
            
            # INFO - General informational messages
            self.__log.info('Successfully processed data {}'.format(data_id))
            self.__log.info(f'Result: {result}')
            
            return result
            
        except ValueError as e:
            # WARNING - Something unexpected but handled
            self.__log.warning('Invalid data format for ID {}: {}'.format(data_id, e))
            self.__log.warning(f'Using default value instead')
            return None
            
        except Exception as e:
            # ERROR - Something failed
            self.__log.error('Failed to process data {}: {}'.format(data_id, str(e)))
            self.__log.error(f'Exception type: {type(e).__name__}')
            raise
    
    def _do_processing(self, data_id: int):
        self.__log.debug(f'Internal processing for {data_id}')
        if data_id < 0:
            raise ValueError("Data ID must be positive")
        return data_id * 2


class UserService:
    def __init__(self):
        # Create logger with custom settings
        settings = LoggerSettings(level='INFO')
        self.__log = get_logger('UserService', settings)
    
    def create_user(self, username: str, email: str):
        """Create user with logging"""
        self.__log.info('Creating user: {}'.format(username))
        
        # Validate
        if not email:
            self.__log.warning('Email not provided for user {}'.format(username))
        
        # Create user object
        user = {'username': username, 'email': email, 'id': 123}
        
        self.__log.info('User created successfully: {}'.format(user['id']))
        self.__log.debug('User details: {}'.format(user))
        
        return user
    
    def delete_user(self, user_id: int):
        """Delete user with logging"""
        self.__log.info(f'Attempting to delete user {user_id}')
        
        try:
            # Simulate deletion
            if user_id == 0:
                raise ValueError("Invalid user ID")
            
            self.__log.info(f'User {user_id} deleted successfully')
            
        except ValueError as e:
            self.__log.error(f'Cannot delete user {user_id}: {e}')
            raise
        except Exception as e:
            self.__log.critical(f'Critical error deleting user {user_id}: {e}')
            raise


# Usage example
if __name__ == '__main__':
    # Example 1: DataProcessor
    processor = DataProcessor('MainProcessor')
    processor.process_data(42)
    processor.process_data(-1)  # Will log warning
    
    # Example 2: UserService
    service = UserService()
    user = service.create_user('alice', 'alice@example.com')
    service.delete_user(user['id'])
```

### Output Example

```
[2024-01-15 10:30:45] | [12345:67890] | [DEBUG] | app.DataProcessor.MainProcessor | Starting to process data 42
[2024-01-15 10:30:45] | [12345:67890] | [DEBUG] | app.DataProcessor.MainProcessor | Processor name: MainProcessor
[2024-01-15 10:30:45] | [12345:67890] | [DEBUG] | app.DataProcessor.MainProcessor | Internal processing for 42
[2024-01-15 10:30:45] | [12345:67890] | [INFO] | app.DataProcessor.MainProcessor | Successfully processed data 42
[2024-01-15 10:30:45] | [12345:67890] | [INFO] | app.DataProcessor.MainProcessor | Result: 84
[2024-01-15 10:30:46] | [12345:67890] | [WARNING] | app.DataProcessor.MainProcessor | Invalid data format for ID -1: Data ID must be positive
[2024-01-15 10:30:46] | [12345:67890] | [WARNING] | app.DataProcessor.MainProcessor | Using default value instead
[2024-01-15 10:30:47] | [12345:67890] | [INFO] | app.UserService | Creating user: alice
[2024-01-15 10:30:47] | [12345:67890] | [INFO] | app.UserService | User created successfully: 123
[2024-01-15 10:30:47] | [12345:67890] | [INFO] | app.UserService | Attempting to delete user 123
[2024-01-15 10:30:47] | [12345:67890] | [INFO] | app.UserService | User 123 deleted successfully
```

---

## Common Logging Methods

### All Log Methods Explained

```python
from logger_config import get_logger

class MyApp:
    def __init__(self):
        self.__log = get_logger('MyApp')
    
    def demonstrate_logging(self):
        # DEBUG - Detailed diagnostic information
        # Use when: Tracking variable values, function calls, internal state
        self.__log.debug('Variable x = {}'.format(42))
        self.__log.debug('Entering function process_data()')
        self.__log.debug(f'Config loaded: {{"timeout": 30, "retries": 3}}')
        
        # INFO - General informational messages
        # Use when: Application started/stopped, user actions, successful operations
        self.__log.info('Application started successfully')
        self.__log.info('User {} logged in'.format('alice'))
        self.__log.info(f'Processing 100 records')
        
        # WARNING - Warning messages (something unexpected but handled)
        # Use when: Deprecated features, recoverable errors, potential issues
        self.__log.warning('Disk space low: {} MB remaining'.format(500))
        self.__log.warning('Using deprecated API endpoint')
        self.__log.warning(f'Retry attempt 3 of 5')
        
        # ERROR - Error messages (something failed)
        # Use when: Operation failed, exception caught, data errors
        self.__log.error('Failed to connect to database: {}'.format('Connection timeout'))
        self.__log.error('Invalid user input: {}'.format({'age': -5}))
        self.__log.error(f'File not found: config.json')
        
        # CRITICAL - Critical errors (application may crash)
        # Use when: Fatal errors, system failures, data corruption
        self.__log.critical('Out of memory, shutting down')
        self.__log.critical('Database connection pool exhausted')
        self.__log.critical(f'Critical security breach detected')
```

### Logging with Exception Information

```python
from logger_config import get_logger

class FileProcessor:
    def __init__(self):
        self.__log = get_logger('FileProcessor')
    
    def read_file(self, filename: str):
        self.__log.info('Reading file: {}'.format(filename))
        
        try:
            with open(filename, 'r') as f:
                data = f.read()
            
            self.__log.debug('File content length: {}'.format(len(data)))
            return data
            
        except FileNotFoundError:
            # Log error with exception info
            self.__log.error('File not found: {}'.format(filename), exc_info=True)
            
        except PermissionError:
            self.__log.error(f'Permission denied: {filename}', exc_info=True)
            
        except Exception as e:
            # Log unexpected errors with full traceback
            self.__log.critical(
                'Unexpected error reading {}: {}'.format(filename, e),
                exc_info=True
            )
            raise
```

---

## Logging to Files

### File Handler Setup

```python
# logger_config_with_file.py
import logging
import sys
from logging.handlers import RotatingFileHandler, TimedRotatingFileHandler

def get_logger_with_file(
        instance_name: str,
        log_level: str = 'DEBUG',
        log_file: str = 'app.log'):
    """Create logger that writes to both console and file"""
    
    logger = logging.getLogger(instance_name)
    logger.setLevel(log_level)
    
    if logger.hasHandlers():
        logger.handlers.clear()
    
    formatter = logging.Formatter(
        '[%(asctime)s] | [%(levelname)s] | %(name)s | %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    
    # Console handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setLevel(log_level)
    console_handler.setFormatter(formatter)
    logger.addHandler(console_handler)
    
    # File handler (rotating by size)
    file_handler = RotatingFileHandler(
        log_file,
        maxBytes=10*1024*1024,  # 10 MB
        backupCount=5  # Keep 5 backup files
    )
    file_handler.setLevel(log_level)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    
    return logger


def get_logger_daily_rotation(
        instance_name: str,
        log_level: str = 'INFO',
        log_file: str = 'app.log'):
    """Create logger that rotates log files daily"""
    
    logger = logging.getLogger(instance_name)
    logger.setLevel(log_level)
    
    if logger.hasHandlers():
        logger.handlers.clear()
    
    formatter = logging.Formatter(
        '[%(asctime)s] | [%(levelname)s] | %(name)s | %(message)s'
    )
    
    # Rotating file handler (daily rotation)
    file_handler = TimedRotatingFileHandler(
        log_file,
        when='midnight',  # Rotate at midnight
        interval=1,       # Every 1 day
        backupCount=30    # Keep 30 days of logs
    )
    file_handler.setLevel(log_level)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    
    return logger
```

### Usage

```python
from logger_config_with_file import get_logger_with_file

class Application:
    def __init__(self):
        self.__log = get_logger_with_file('Application', log_file='myapp.log')
    
    def run(self):
        self.__log.info('Application starting...')
        # Logs to both console and myapp.log file
        
        self.__log.debug('Debug information')
        self.__log.info('Processing complete')
```

---

## Best Practices

### 1. Use Descriptive Logger Names

```python
# ✅ Good - clear hierarchy
self.__log = get_logger('myapp.services.UserService')
self.__log = get_logger('myapp.database.Connection')

# ❌ Bad - unclear
self.__log = get_logger('logger')
self.__log = get_logger('log1')
```

### 2. Choose Appropriate Log Levels

```python
# ✅ Good
self.__log.debug('Variable value: {}'.format(x))  # For debugging
self.__log.info('User {} created'.format(user_id))  # Important events
self.__log.warning('Retry attempt {}'.format(retry))  # Potential issues
self.__log.error('Database error: {}'.format(e))  # Failures
self.__log.critical('System failure!')  # Fatal errors

# ❌ Bad
self.__log.error('User logged in')  # Should be INFO
self.__log.debug('Database crashed')  # Should be CRITICAL
```

### 3. Use Lazy Formatting

```python
# ✅ Good - only formats if log level allows
self.__log.debug('Processing user %s', user_id)

# ❌ Bad - always formats even if not logged
self.__log.debug('Processing user {}'.format(user_id))

# Both work, but lazy formatting is more efficient
```

### 4. Log Exceptions Properly

```python
# ✅ Good - includes traceback
try:
    risky_operation()
except Exception as e:
    self.__log.error('Operation failed: {}'.format(e), exc_info=True)

# ❌ Bad - no context
try:
    risky_operation()
except:
    self.__log.error('Error')  # What error? Where?
```

### 5. Don't Log Sensitive Data

```python
# ❌ Bad - exposes sensitive data
self.__log.info('User password: {}'.format(password))
self.__log.debug('Credit card: {}'.format(card_number))

# ✅ Good - mask or omit sensitive data
self.__log.info('User authenticated')
self.__log.debug('Payment processed for user {}'.format(user_id))
```

---

## Complete Real-World Example

```python
# my_application.py
from logger_config import get_logger, LoggerSettings
from typing import Optional, Dict, Any

class DatabaseConnection:
    """Database connection with comprehensive logging"""
    
    def __init__(self, host: str, port: int):
        self.__log = get_logger('myapp.database.Connection')
        self.host = host
        self.port = port
        self.connected = False
        
        self.__log.debug('Database connection initialized: {}:{}'.format(host, port))
    
    def connect(self):
        """Connect to database"""
        self.__log.info('Connecting to database at {}:{}'.format(self.host, self.port))
        
        try:
            # Simulate connection
            self.__log.debug('Establishing TCP connection...')
            self.__log.debug('Authenticating...')
            
            self.connected = True
            self.__log.info('Successfully connected to database')
            
        except ConnectionError as e:
            self.__log.error('Failed to connect: {}'.format(e), exc_info=True)
            raise
        except Exception as e:
            self.__log.critical('Unexpected connection error: {}'.format(e), exc_info=True)
            raise
    
    def execute_query(self, query: str):
        """Execute database query"""
        self.__log.debug('Executing query: {}'.format(query[:100]))  # Truncate long queries
        
        if not self.connected:
            self.__log.error('Cannot execute query: not connected')
            raise RuntimeError("Not connected to database")
        
        try:
            # Simulate query execution
            result = {'rows': 42}
            self.__log.info('Query executed successfully, {} rows affected'.format(result['rows']))
            return result
            
        except Exception as e:
            self.__log.error('Query execution failed: {}'.format(e), exc_info=True)
            raise


class UserManager:
    """User management with logging"""
    
    def __init__(self, db: DatabaseConnection):
        # Use custom log settings
        settings = LoggerSettings(level='INFO')
        self.__log = get_logger('myapp.services.UserManager', settings)
        self.db = db
        
        self.__log.debug('UserManager initialized')
    
    def create_user(self, username: str, email: str) -> Dict[str, Any]:
        """Create a new user"""
        self.__log.info('Creating user: {}'.format(username))
        
        # Validation
        if not username or len(username) < 3:
            self.__log.warning('Invalid username length: {}'.format(len(username)))
            raise ValueError("Username must be at least 3 characters")
        
        if '@' not in email:
            self.__log.error('Invalid email format: {}'.format(email))
            raise ValueError("Invalid email format")
        
        try:
            # Create user in database
            self.__log.debug('Inserting user into database...')
            query = f"INSERT INTO users (username, email) VALUES ('{username}', '{email}')"
            self.db.execute_query(query)
            
            user = {'id': 123, 'username': username, 'email': email}
            self.__log.info('User created successfully: ID={}'.format(user['id']))
            
            return user
            
        except Exception as e:
            self.__log.error('Failed to create user {}: {}'.format(username, e), exc_info=True)
            raise
    
    def get_user(self, user_id: int) -> Optional[Dict[str, Any]]:
        """Get user by ID"""
        self.__log.debug('Fetching user: {}'.format(user_id))
        
        try:
            query = f"SELECT * FROM users WHERE id = {user_id}"
            result = self.db.execute_query(query)
            
            if result['rows'] == 0:
                self.__log.warning('User not found: {}'.format(user_id))
                return None
            
            user = {'id': user_id, 'username': 'alice', 'email': 'alice@example.com'}
            self.__log.info('User retrieved: {}'.format(user_id))
            
            return user
            
        except Exception as e:
            self.__log.error('Error fetching user {}: {}'.format(user_id, e), exc_info=True)
            return None


# Main application
if __name__ == '__main__':
    # Create logger for main
    log = get_logger('myapp.main')
    
    log.info('Application starting...')
    
    try:
        # Initialize database
        db = DatabaseConnection('localhost', 5432)
        db.connect()
        
        # Create user manager
        user_manager = UserManager(db)
        
        # Create users
        user1 = user_manager.create_user('alice', 'alice@example.com')
        log.info('Created user: {}'.format(user1['id']))
        
        user2 = user_manager.create_user('bob', 'bob@example.com')
        log.info('Created user: {}'.format(user2['id']))
        
        # Retrieve user
        retrieved = user_manager.get_user(user1['id'])
        log.debug('Retrieved user: {}'.format(retrieved))
        
        log.info('Application completed successfully')
        
    except Exception as e:
        log.critical('Application failed: {}'.format(e), exc_info=True)
        raise
```

---

## Quick Reference

### Log Level Decision Tree

```
Is it a bug/diagnostic info? → DEBUG
Is it general information? → INFO
Is it unexpected but handled? → WARNING
Did an operation fail? → ERROR
Is it a fatal system error? → CRITICAL
```

### Common Format Strings

```python
# Simple format
'[%(levelname)s] %(message)s'

# With timestamp
'[%(asctime)s] %(levelname)s - %(message)s'

# With module and function
'%(asctime)s - %(name)s - %(funcName)s - %(levelname)s - %(message)s'

# Production format (detailed)
'[%(asctime)s] | [%(process)d:%(thread)d] | [%(levelname)s] | %(name)s | %(message)s'
```

### Formatting Options

```python
# String formatting
self.__log.info('User {} logged in'.format(username))

# Multiple values
self.__log.debug('Processing {}: {} items'.format(batch_id, count))

# f-strings (Python 3.6+)
self.__log.info(f'User {username} logged in from {ip_address}')

# Named placeholders
self.__log.error('Error in %(module)s: %(error)s', {'module': 'auth', 'error': str(e)})
```

---

**Navigation:**
- [← Previous: Frameworks & Libraries](#/py-frameworks-libraries)
- [↑ Back to Python Basics](#/py-basics)
- [🏠 Home](#/home)
