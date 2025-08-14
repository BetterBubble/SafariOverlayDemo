# SafariOverlayDemo
Поведение как в Safari: полупрозрачная панель (overlay) умно скрывается при прокрутке вниз и появляется при прокрутке вверх. Реализовано на UIKit с аккуратной анимацией и чистым разделением ответственности.

SafariOverlayDemo — Safari‑style overlay при скролле (UIKit)

Фичи
	•	Safari‑подобный overlay при скролле: плавное скрытие/появление с доводкой состояния до 0/1.
	•	Инкапсуляция логики: отдельный VisibilityDelegate (контроллер не перегружен).
	•	Pixel‑perfect математика: clamp, округление к scale экрана — без «дрожи» при анимации.
	•	Список проектов (ProjectListVC) на UICollectionView с CustomFlowLayout.
	•	Экран проекта (ProjectVC): UITableView + UIVisualEffectView в роли overlay.
	•	Адаптивные отступы: корректные contentInset и scrollIndicatorInsets под высоту overlay.

Как это работает
	ProjectVC делегирует события UIScrollViewDelegate в VisibilityDelegate.
	VisibilityDelegate: запоминает начальный оффсет (scrollViewWillBeginDragging)
	по scrollViewDidScroll считает дельту и обновляет currentVisibility с порогом threshold
	при окончании инерции доводит состояние до 0 или 1 (приятный UX)
	Контроллер в viewWillLayoutSubviews через ProjectViewLayoute пересчитывает фреймы
  с учётом currentVisibility и обновляет contentInset, чтобы контент не «подпрыгивал».

Технологии
	•	UIKit: UICollectionView, UITableView, UIScrollViewDelegate
	•	UIVisualEffectView (blur‑overlay)
	•	UIView/Core Animation (кастомные тайминги, сглаживание)
	•	Чистая композиция: делегирование поведения вместо «God‑VC»
	•	Утилиты для clamp/округления к UIScreen.main.scale
