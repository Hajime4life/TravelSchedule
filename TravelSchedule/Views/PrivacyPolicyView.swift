import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    @EnvironmentObject var navigation: NavigationViewModel
    
    var body: some View {
        
        Group {
            asText()
        }
        .navigationTitle("Пользовательское соглашение")
        .onAppear {
            navigation.showTabBar = .hidden
        }
        .onDisappear {
            navigation.showTabBar = .visible
        }
    }
    
    // TODO: попробовать сделать с WebView, не вышло вернул текстом
    @ViewBuilder private func web() -> some View {
        if let url = URL(string: "https://yandex.ru/legal/practicum_offer") {
            WebView(url: url)
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder private func asText() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Оферта на оказание образовательных услуг дополнительного образования Яндекс.Практикум для физических лиц")
                    .bold()
                    .font(.system(size: 24))
                Text("Данный документ является действующим, если расположен по адресу: https://yandex.ru/legal/practicum_offer\n\nРоссийская Федерация, город Москва")
                Text("1. ТЕРМИНЫ")
                    .bold()
                    .font(.system(size: 24))
                    .padding(.top, 24)
                Text("""
                Понятия, используемые в Оферте, означают следующее:  Авторизованные адреса — адреса электронной почты каждой Стороны. Авторизованным адресом Исполнителя является адрес электронной почты, указанный в разделе 11 Оферты. Авторизованным адресом Студента является адрес электронной почты, указанный Студентом в Личном кабинете.  Вводный курс — начальный Курс обучения по представленным на Сервисе Программам обучения в рамках выбранной Студентом Профессии или Курсу, рассчитанный на определенное количество часов самостоятельного обучения, который предоставляется Студенту единожды при регистрации на Сервисе на безвозмездной основе. В процессе обучения в рамках Вводного курса Студенту предоставляется возможность ознакомления с работой Сервиса и определения возможности Студента продолжить обучение в рамках Полного курса по выбранной Студентом Программе обучения. Точное количество часов обучения в рамках Вводного курса зависит от выбранной Студентом Профессии или Курса и определяется в Программе обучения, размещенной на Сервисе. Максимальный срок освоения Вводного курса составляет 1 (один) год с даты начала обучения.
                """)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.whiteDay.ignoresSafeArea())
    }
}



#Preview {
    PrivacyPolicyView()
}
