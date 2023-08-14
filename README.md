# CostControlApp
![iOS](https://img.shields.io/badge/iOS-16+%20-white?logo=Apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.5-red?logo=Swift&logoColor=red)
![Xcode](https://img.shields.io/badge/Xcode-14.3%20-00B2FF?logo=Xcode&logoColor=00B2FF)

Предаттестационный проект для Skillbox (продублирован с рабочего репозитория Skillbox на GitLab).

Данный проект представляет собой приложение, позволяющее пользователю контролировать баланс своих доходов и расходов, а также наблюдать за ними в графическом виде.
- Внесение доходов и расходов по датам
- Возможность добавления категории трат
- Демонстрация баланса доходов/расходов в виде сводного графика
- Отдельный график расходов для каждой категории
- Графики могут отображать данные за период недели, месяца, квартала и года

## Preview
Экраны приложения:
| Income | Schedule | Expenses |
:---:|:---:|:---:
![IncomeScreen](https://github.com/2late2bad/CostControlApp/assets/121951550/07d5ece2-7548-4af6-80b1-b41a9611039b) | ![ScheduleScreen](https://github.com/2late2bad/CostControlApp/assets/121951550/9f0efcea-16ba-494a-91db-de5e2fed6665) | ![ExpensesScreen](https://github.com/2late2bad/CostControlApp/assets/121951550/5ce845b0-c1f8-4c78-9f6b-219473853f77)

## Tech stack
* SwiftUI
* MVVM
* Charts
* UserDefaults

## Highlights
* Анимированные графики Charts
* Кастомные оси графиков и расширенный диапазон значений
* Показ периода в графике, актуализированный по дате
* Единый GeneralEnvironment, отвечающий за баланс доходов и расходов
* TabBarRouter
* ViewBuilder
* Сохранение всех данных пользователя в UserDefaults
* Без использования сторонних библиотек
