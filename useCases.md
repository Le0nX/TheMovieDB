[Назад](README.md)
# Use Cases

### Login Use Case

#### Data:
- URL
- Login
- Password
- Session Token

#### Primary course (happy path):
1. Исполняем команду "Login" с данным выше.
2. Система получает ответ от URL.
3. Система валидирует полученные данные.
4. Система 
5. Система пускает юзера на следующий экран

#### Invalid data – error course (sad path):
1. Система показывает сообщение о том, что логин/пароль неверны.

#### No connectivity – error course (sad path):
1. Система показывает сообщение об ошибке соединения

---

### OTP Use Case

#### Data:
- PIN

#### Primary course (happy path):
1. Вводим пин.
2. Система валидирует полученные данные.
3. Система пускает юзера на следующий экран

#### Invalid PIN – error course (sad path):
1. Система показывает сообщение о том, что PIN неверный.

---

### Search Use Case

#### Data:
- Название фильма

---

### Show Search Results in table view Use Case

---

### Show Search Results in collection view Use Case

---

### Show Search Result in detail Use Case

---

### Add/Remove Favorites Use Case

---

### Show Favorites Collection View Use Case

---

### Show Favorites Table View Use Case

---

### Show Profile Use Case

---

### Logout Use Case

---