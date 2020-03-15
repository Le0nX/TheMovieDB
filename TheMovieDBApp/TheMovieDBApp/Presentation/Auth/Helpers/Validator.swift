//
//  Validator.swift
//  TheMovieDBApp
//
//  Created by Denis Nefedov on 09.03.2020.
//  Copyright © 2020 Den4ik's Team. All rights reserved.
//

import Foundation

/// Проверяет валидацию данных. Я проверил у них на сайте:
/// Логин может быть 1 символ. Пароль от 4 символов без обязательного содержания заглавных символов и цифр
/// Удалось даже зарегестрировать пользователя с логином: ' и паролем: -'-', также логином могут быть и емэйл с телефоном....
func isValid(_ login: String, with password: String) -> Bool {
    let firstCond = !login.isEmpty
    let secondCond = password.count > 3
    
    return ( firstCond && secondCond )
}
