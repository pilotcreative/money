# encoding: utf-8

class Money

  # Represents a specific currency unit.
  class Currency
    include Comparable

    # Thrown when an unknown currency is requested.
    class UnknownCurrency < StandardError; end

    # List of attributes applicable to a currency object.
    ATTRIBUTES = [ :priority, :iso_code, :name, :symbol, :subunit, :subunit_to_unit, :separator, :delimiter, :format ]

    # List of known currencies.
    #
    # == monetary unit
    # The standard unit of value of a currency, as the dollar in the United States or the peso in Mexico.
    # http://www.answers.com/topic/monetary-unit
    # == fractional monetary unit, subunit
    # A monetary unit that is valued at a fraction (usually one hundredth) of the basic monetary unit
    # http://www.answers.com/topic/fractional-monetary-unit-subunit
    #
    # See http://en.wikipedia.org/wiki/List_of_circulating_currencies
    TABLE = {
      :aed => { :priority => 100, :iso_code => "AED", :name => "United Arab Emirates Dirham",               :symbol => "د.إ",           :subunit => "Fils",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :afn => { :priority => 100, :iso_code => "AFN", :name => "Afghan Afghani",                            :symbol => "؋",             :subunit => "Pul",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :all => { :priority => 100, :iso_code => "ALL", :name => "Albanian Lek",                              :symbol => "L",             :subunit => "Qintar",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :amd => { :priority => 100, :iso_code => "AMD", :name => "Armenian Dram",                             :symbol => "դր.",           :subunit => "Luma",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ang => { :priority => 100, :iso_code => "ANG", :name => "Netherlands Antillean Gulden",              :symbol => "ƒ",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :aoa => { :priority => 100, :iso_code => "AOA", :name => "Angolan Kwanza",                            :symbol => "Kz",            :subunit => "Cêntimo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ars => { :priority => 100, :iso_code => "ARS", :name => "Argentine Peso",                            :symbol => "$",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :aud => { :priority =>   4, :iso_code => "AUD", :name => "Australian Dollar",                         :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :awg => { :priority => 100, :iso_code => "AWG", :name => "Aruban Florin",                             :symbol => "ƒ",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :azn => { :priority => 100, :iso_code => "AZN", :name => "Azerbaijani Manat",                         :symbol => nil,             :subunit => "Qəpik",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bam => { :priority => 100, :iso_code => "BAM", :name => "Bosnia and Herzegovina Convertible Mark",   :symbol => "KM or КМ",      :subunit => "Fening",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bbd => { :priority => 100, :iso_code => "BBD", :name => "Barbadian Dollar",                          :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bdt => { :priority => 100, :iso_code => "BDT", :name => "Bangladeshi Taka",                          :symbol => "৳",             :subunit => "Paisa",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bgn => { :priority => 100, :iso_code => "BGN", :name => "Bulgarian Lev",                             :symbol => "лв",            :subunit => "Stotinka",      :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bhd => { :priority => 100, :iso_code => "BHD", :name => "Bahraini Dinar",                            :symbol => "ب.د",           :subunit => "Fils",          :subunit_to_unit => 1000,  :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bif => { :priority => 100, :iso_code => "BIF", :name => "Burundian Franc",                           :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bmd => { :priority => 100, :iso_code => "BMD", :name => "Bermudian Dollar",                          :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bnd => { :priority => 100, :iso_code => "BND", :name => "Brunei Dollar",                             :symbol => "$",             :subunit => "Sen",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bob => { :priority => 100, :iso_code => "BOB", :name => "Bolivian Boliviano",                        :symbol => "Bs.",           :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :brl => { :priority => 100, :iso_code => "BRL", :name => "Brazilian Real",                            :symbol => "R$ ",            :subunit => "Centavo",      :subunit_to_unit => 100,   :separator => ",", :delimiter => ".", :format => "%u%n" },
      :bsd => { :priority => 100, :iso_code => "BSD", :name => "Bahamian Dollar",                           :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :btn => { :priority => 100, :iso_code => "BTN", :name => "Bhutanese Ngultrum",                        :symbol => nil,             :subunit => "Chertrum",      :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bwp => { :priority => 100, :iso_code => "BWP", :name => "Botswana Pula",                             :symbol => "P",             :subunit => "Thebe",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :byr => { :priority => 100, :iso_code => "BYR", :name => "Belarusian Ruble",                          :symbol => "Br",            :subunit => "Kapyeyka",      :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :bzd => { :priority => 100, :iso_code => "BZD", :name => "Belize Dollar",                             :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :cad => { :priority =>   5, :iso_code => "CAD", :name => "Canadian Dollar",                           :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :cdf => { :priority => 100, :iso_code => "CDF", :name => "Congolese Franc",                           :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :chf => { :priority => 100, :iso_code => "CHF", :name => "Swiss Franc",                               :symbol => "Fr",            :subunit => "Rappen",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :clp => { :priority => 100, :iso_code => "CLP", :name => "Chilean Peso",                              :symbol => "$",             :subunit => "Peso",          :subunit_to_unit => 1,     :separator => ",", :delimiter => ".", :format => "%u%n" },
      :cny => { :priority => 100, :iso_code => "CNY", :name => "Chinese Renminbi Yuan",                     :symbol => "¥",             :subunit => "Jiao",          :subunit_to_unit => 10,    :separator => ".", :delimiter => ",", :format => "%u%n" },
      :cop => { :priority => 100, :iso_code => "COP", :name => "Colombian Peso",                            :symbol => "$",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :crc => { :priority => 100, :iso_code => "CRC", :name => "Costa Rican Colón",                         :symbol => "₡",             :subunit => "Céntimo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :cuc => { :priority => 100, :iso_code => "CUC", :name => "Cuban Convertible Peso",                    :symbol => "$",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :cup => { :priority => 100, :iso_code => "CUP", :name => "Cuban Peso",                                :symbol => "$",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :cve => { :priority => 100, :iso_code => "CVE", :name => "Cape Verdean Escudo",                       :symbol => "$ or Esc",      :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :czk => { :priority => 100, :iso_code => "CZK", :name => "Czech Koruna",                              :symbol => "Kč",            :subunit => "Haléř",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :djf => { :priority => 100, :iso_code => "DJF", :name => "Djiboutian Franc",                          :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :dkk => { :priority => 100, :iso_code => "DKK", :name => "Danish Krone",                              :symbol => "kr",            :subunit => "Øre",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :dop => { :priority => 100, :iso_code => "DOP", :name => "Dominican Peso",                            :symbol => "$",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :dzd => { :priority => 100, :iso_code => "DZD", :name => "Algerian Dinar",                            :symbol => "د.ج",           :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :eek => { :priority => 100, :iso_code => "EEK", :name => "Estonian Kroon",                            :symbol => "KR",            :subunit => "Sent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :egp => { :priority => 100, :iso_code => "EGP", :name => "Egyptian Pound",                            :symbol => "£ or ج.م",      :subunit => "Piastre",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ern => { :priority => 100, :iso_code => "ERN", :name => "Eritrean Nakfa",                            :symbol => "Nfk",           :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :etb => { :priority => 100, :iso_code => "ETB", :name => "Ethiopian Birr",                            :symbol => nil,             :subunit => "Santim",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :eur => { :priority =>   2, :iso_code => "EUR", :name => "Euro",                                      :symbol => "€",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :fjd => { :priority => 100, :iso_code => "FJD", :name => "Fijian Dollar",                             :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :fkp => { :priority => 100, :iso_code => "FKP", :name => "Falkland Pound",                            :symbol => "£",             :subunit => "Penny",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gbp => { :priority =>   3, :iso_code => "GBP", :name => "British Pound",                             :symbol => "£",             :subunit => "Penny",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gel => { :priority => 100, :iso_code => "GEL", :name => "Georgian Lari",                             :symbol => "ლ",             :subunit => "Tetri",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ghs => { :priority => 100, :iso_code => "GHS", :name => "Ghanaian Cedi",                             :symbol => "₵",             :subunit => "Pesewa",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gip => { :priority => 100, :iso_code => "GIP", :name => "Gibraltar Pound",                           :symbol => "£",             :subunit => "Penny",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gmd => { :priority => 100, :iso_code => "GMD", :name => "Gambian Dalasi",                            :symbol => "D",             :subunit => "Butut",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gnf => { :priority => 100, :iso_code => "GNF", :name => "Guinean Franc",                             :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gtq => { :priority => 100, :iso_code => "GTQ", :name => "Guatemalan Quetzal",                        :symbol => "Q",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :gyd => { :priority => 100, :iso_code => "GYD", :name => "Guyanese Dollar",                           :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :hkd => { :priority => 100, :iso_code => "HKD", :name => "Hong Kong Dollar",                          :symbol => "$",             :subunit => "Ho",            :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :hnl => { :priority => 100, :iso_code => "HNL", :name => "Honduran Lempira",                          :symbol => "L",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :hrk => { :priority => 100, :iso_code => "HRK", :name => "Croatian Kuna",                             :symbol => "kn",            :subunit => "Lipa",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :htg => { :priority => 100, :iso_code => "HTG", :name => "Haitian Gourde",                            :symbol => "G",             :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :huf => { :priority => 100, :iso_code => "HUF", :name => "Hungarian Forint",                          :symbol => "Ft",            :subunit => "Fillér",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :idr => { :priority => 100, :iso_code => "IDR", :name => "Indonesian Rupiah",                         :symbol => "Rp",            :subunit => "Sen",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ils => { :priority => 100, :iso_code => "ILS", :name => "Israeli New Sheqel",                        :symbol => "₪",             :subunit => "Agora",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :inr => { :priority => 100, :iso_code => "INR", :name => "Indian Rupee",                              :symbol => "₨",             :subunit => "Paisa",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :iqd => { :priority => 100, :iso_code => "IQD", :name => "Iraqi Dinar",                               :symbol => "ع.د",           :subunit => "Fils",          :subunit_to_unit => 1000,  :separator => ".", :delimiter => ",", :format => "%u%n" },
      :irr => { :priority => 100, :iso_code => "IRR", :name => "Iranian Rial",                              :symbol => "﷼",             :subunit => "Dinar",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :isk => { :priority => 100, :iso_code => "ISK", :name => "Icelandic Króna",                           :symbol => "kr",            :subunit => "Eyrir",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :jmd => { :priority => 100, :iso_code => "JMD", :name => "Jamaican Dollar",                           :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :jod => { :priority => 100, :iso_code => "JOD", :name => "Jordanian Dinar",                           :symbol => "د.ا",           :subunit => "Piastre",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :jpy => { :priority =>   6, :iso_code => "JPY", :name => "Japanese Yen",                              :symbol => "¥",             :subunit => "Sen",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kes => { :priority => 100, :iso_code => "KES", :name => "Kenyan Shilling",                           :symbol => "Sh",            :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kgs => { :priority => 100, :iso_code => "KGS", :name => "Kyrgyzstani Som",                           :symbol => nil,             :subunit => "Tyiyn",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :khr => { :priority => 100, :iso_code => "KHR", :name => "Cambodian Riel",                            :symbol => "៛",             :subunit => "Sen",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kmf => { :priority => 100, :iso_code => "KMF", :name => "Comorian Franc",                            :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kpw => { :priority => 100, :iso_code => "KPW", :name => "North Korean Won",                          :symbol => "₩",             :subunit => "Chŏn",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :krw => { :priority => 100, :iso_code => "KRW", :name => "South Korean Won",                          :symbol => "₩",             :subunit => "Jeon",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kwd => { :priority => 100, :iso_code => "KWD", :name => "Kuwaiti Dinar",                             :symbol => "د.ك",           :subunit => "Fils",          :subunit_to_unit => 1000,  :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kyd => { :priority => 100, :iso_code => "KYD", :name => "Cayman Islands Dollar",                     :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :kzt => { :priority => 100, :iso_code => "KZT", :name => "Kazakhstani Tenge",                         :symbol => "〒",             :subunit => "Tiyn",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lak => { :priority => 100, :iso_code => "LAK", :name => "Lao Kip",                                   :symbol => "₭",             :subunit => "Att",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lbp => { :priority => 100, :iso_code => "LBP", :name => "Lebanese Lira",                             :symbol => "ل.ل",           :subunit => "Piastre",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lkr => { :priority => 100, :iso_code => "LKR", :name => "Sri Lankan Rupee",                          :symbol => "₨",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lrd => { :priority => 100, :iso_code => "LRD", :name => "Liberian Dollar",                           :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lsl => { :priority => 100, :iso_code => "LSL", :name => "Lesotho Loti",                              :symbol => "L",             :subunit => "Sente",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ltl => { :priority => 100, :iso_code => "LTL", :name => "Lithuanian Litas",                          :symbol => "Lt",            :subunit => "Centas",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lvl => { :priority => 100, :iso_code => "LVL", :name => "Latvian Lats",                              :symbol => "Ls",            :subunit => "Santīms",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :lyd => { :priority => 100, :iso_code => "LYD", :name => "Libyan Dinar",                              :symbol => "ل.د",           :subunit => "Dirham",        :subunit_to_unit => 1000,  :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mad => { :priority => 100, :iso_code => "MAD", :name => "Moroccan Dirham",                           :symbol => "د.م.",          :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mdl => { :priority => 100, :iso_code => "MDL", :name => "Moldovan Leu",                              :symbol => "L",             :subunit => "Ban",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mga => { :priority => 100, :iso_code => "MGA", :name => "Malagasy Ariary",                           :symbol => nil,             :subunit => "Iraimbilanja",  :subunit_to_unit => 5,     :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mkd => { :priority => 100, :iso_code => "MKD", :name => "Macedonian Denar",                          :symbol => "ден",           :subunit => "Deni",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mmk => { :priority => 100, :iso_code => "MMK", :name => "Myanmar Kyat",                              :symbol => "K",             :subunit => "Pya",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mnt => { :priority => 100, :iso_code => "MNT", :name => "Mongolian Tögrög",                          :symbol => "₮",             :subunit => "Möngö",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mop => { :priority => 100, :iso_code => "MOP", :name => "Macanese Pataca",                           :symbol => "P",             :subunit => "Avo",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mro => { :priority => 100, :iso_code => "MRO", :name => "Mauritanian Ouguiya",                       :symbol => "UM",            :subunit => "Khoums",        :subunit_to_unit => 5,     :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mur => { :priority => 100, :iso_code => "MUR", :name => "Mauritian Rupee",                           :symbol => "₨",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mvr => { :priority => 100, :iso_code => "MVR", :name => "Maldivian Rufiyaa",                         :symbol => "ރ.",            :subunit => "Laari",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mwk => { :priority => 100, :iso_code => "MWK", :name => "Malawian Kwacha",                           :symbol => "MK",            :subunit => "Tambala",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mxn => { :priority => 100, :iso_code => "MXN", :name => "Mexican Peso",                              :symbol => "$",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :myr => { :priority => 100, :iso_code => "MYR", :name => "Malaysian Ringgit",                         :symbol => "RM",            :subunit => "Sen",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :mzn => { :priority => 100, :iso_code => "MZN", :name => "Mozambican Metical",                        :symbol => "MTn",           :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :nad => { :priority => 100, :iso_code => "NAD", :name => "Namibian Dollar",                           :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ngn => { :priority => 100, :iso_code => "NGN", :name => "Nigerian Naira",                            :symbol => "₦",             :subunit => "Kobo",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :nio => { :priority => 100, :iso_code => "NIO", :name => "Nicaraguan Córdoba",                        :symbol => "C$",            :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :nok => { :priority => 100, :iso_code => "NOK", :name => "Norwegian Krone",                           :symbol => "kr",            :subunit => "Øre",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :npr => { :priority => 100, :iso_code => "NPR", :name => "Nepalese Rupee",                            :symbol => "₨",             :subunit => "Paisa",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :nzd => { :priority => 100, :iso_code => "NZD", :name => "New Zealand Dollar",                        :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :omr => { :priority => 100, :iso_code => "OMR", :name => "Omani Rial",                                :symbol => "ر.ع.",          :subunit => "Baisa",         :subunit_to_unit => 1000,  :separator => ".", :delimiter => ",", :format => "%u%n" },
      :pab => { :priority => 100, :iso_code => "PAB", :name => "Panamanian Balboa",                         :symbol => "B/.",           :subunit => "Centésimo",     :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :pen => { :priority => 100, :iso_code => "PEN", :name => "Peruvian Nuevo Sol",                        :symbol => "S/.",           :subunit => "Céntimo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :pgk => { :priority => 100, :iso_code => "PGK", :name => "Papua New Guinean Kina",                    :symbol => "K",             :subunit => "Toea",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :php => { :priority => 100, :iso_code => "PHP", :name => "Philippine Peso",                           :symbol => "₱",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :pkr => { :priority => 100, :iso_code => "PKR", :name => "Pakistani Rupee",                           :symbol => "₨",             :subunit => "Paisa",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :pln => { :priority => 100, :iso_code => "PLN", :name => "Polish Złoty",                              :symbol => "zł",            :subunit => "Grosz",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%n %u" },
      :pyg => { :priority => 100, :iso_code => "PYG", :name => "Paraguayan Guaraní",                        :symbol => "₲",             :subunit => "Céntimo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :qar => { :priority => 100, :iso_code => "QAR", :name => "Qatari Riyal",                              :symbol => "ر.ق",           :subunit => "Dirham",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ron => { :priority => 100, :iso_code => "RON", :name => "Romanian Leu",                              :symbol => "L",             :subunit => "Ban",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :rsd => { :priority => 100, :iso_code => "RSD", :name => "Serbian Dinar",                             :symbol => "din. or дин.",  :subunit => "Para",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :rub => { :priority => 100, :iso_code => "RUB", :name => "Russian Ruble",                             :symbol => "р.",            :subunit => "Kopek",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :rwf => { :priority => 100, :iso_code => "RWF", :name => "Rwandan Franc",                             :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sar => { :priority => 100, :iso_code => "SAR", :name => "Saudi Riyal",                               :symbol => "ر.س",           :subunit => "Hallallah",     :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sbd => { :priority => 100, :iso_code => "SBD", :name => "Solomon Islands Dollar",                    :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :scr => { :priority => 100, :iso_code => "SCR", :name => "Seychellois Rupee",                         :symbol => "₨",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sdg => { :priority => 100, :iso_code => "SDG", :name => "Sudanese Pound",                            :symbol => "£",             :subunit => "Piastre",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sek => { :priority => 100, :iso_code => "SEK", :name => "Swedish Krona",                             :symbol => "kr",            :subunit => "Öre",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sgd => { :priority => 100, :iso_code => "SGD", :name => "Singapore Dollar",                          :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :shp => { :priority => 100, :iso_code => "SHP", :name => "Saint Helenian Pound",                      :symbol => "£",             :subunit => "Penny",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :skk => { :priority => 100, :iso_code => "SKK", :name => "Slovak Koruna",                             :symbol => "Sk",            :subunit => "Halier",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sll => { :priority => 100, :iso_code => "SLL", :name => "Sierra Leonean Leone",                      :symbol => "Le",            :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :sos => { :priority => 100, :iso_code => "SOS", :name => "Somali Shilling",                           :symbol => "Sh",            :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :srd => { :priority => 100, :iso_code => "SRD", :name => "Surinamese Dollar",                         :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :std => { :priority => 100, :iso_code => "STD", :name => "São Tomé and Príncipe Dobra",               :symbol => "Db",            :subunit => "Cêntimo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :svc => { :priority => 100, :iso_code => "SVC", :name => "Salvadoran Colón",                          :symbol => "₡",             :subunit => "Centavo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :syp => { :priority => 100, :iso_code => "SYP", :name => "Syrian Pound",                              :symbol => "£ or ل.س",      :subunit => "Piastre",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :szl => { :priority => 100, :iso_code => "SZL", :name => "Swazi Lilangeni",                           :symbol => "L",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :thb => { :priority => 100, :iso_code => "THB", :name => "Thai Baht",                                 :symbol => "฿",             :subunit => "Satang",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :tjs => { :priority => 100, :iso_code => "TJS", :name => "Tajikistani Somoni",                        :symbol => "ЅМ",            :subunit => "Diram",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :tmm => { :priority => 100, :iso_code => "TMM", :name => "Turkmenistani Manat",                       :symbol => "m",             :subunit => "Tennesi",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :tnd => { :priority => 100, :iso_code => "TND", :name => "Tunisian Dinar",                            :symbol => "د.ت",           :subunit => "Millime",       :subunit_to_unit => 1000,  :separator => ".", :delimiter => ",", :format => "%u%n" },
      :top => { :priority => 100, :iso_code => "TOP", :name => "Tongan Paʻanga",                            :symbol => "T$",            :subunit => "Seniti",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :try => { :priority => 100, :iso_code => "TRY", :name => "Turkish New Lira",                          :symbol => "YTL",           :subunit => "New kuruş",     :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ttd => { :priority => 100, :iso_code => "TTD", :name => "Trinidad and Tobago Dollar",                :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :twd => { :priority => 100, :iso_code => "TWD", :name => "New Taiwan Dollar",                         :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :tzs => { :priority => 100, :iso_code => "TZS", :name => "Tanzanian Shilling",                        :symbol => "Sh",            :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :uah => { :priority => 100, :iso_code => "UAH", :name => "Ukrainian Hryvnia",                         :symbol => "₴",             :subunit => "Kopiyka",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :ugx => { :priority => 100, :iso_code => "UGX", :name => "Ugandan Shilling",                          :symbol => "Sh",            :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :usd => { :priority =>   1, :iso_code => "USD", :name => "United States Dollar",                      :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :uyu => { :priority => 100, :iso_code => "UYU", :name => "Uruguayan Peso",                            :symbol => "$",             :subunit => "Centésimo",     :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :uzs => { :priority => 100, :iso_code => "UZS", :name => "Uzbekistani Som",                           :symbol => nil,             :subunit => "Tiyin",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :vef => { :priority => 100, :iso_code => "VEF", :name => "Venezuelan Bolívar",                        :symbol => "Bs F",          :subunit => "Céntimo",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :vnd => { :priority => 100, :iso_code => "VND", :name => "Vietnamese Đồng",                           :symbol => "₫",             :subunit => "Hào",           :subunit_to_unit => 10,    :separator => ".", :delimiter => ",", :format => "%u%n" },
      :vuv => { :priority => 100, :iso_code => "VUV", :name => "Vanuatu Vatu",                              :symbol => "Vt",            :subunit => nil,             :subunit_to_unit => 1,     :separator => ".", :delimiter => ",", :format => "%u%n" },
      :wst => { :priority => 100, :iso_code => "WST", :name => "Samoan Tala",                               :symbol => "T",             :subunit => "Sene",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :xaf => { :priority => 100, :iso_code => "XAF", :name => "Central African Cfa Franc",                 :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :xcd => { :priority => 100, :iso_code => "XCD", :name => "East Caribbean Dollar",                     :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :xof => { :priority => 100, :iso_code => "XOF", :name => "West African Cfa Franc",                    :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :xpf => { :priority => 100, :iso_code => "XPF", :name => "Cfp Franc",                                 :symbol => "Fr",            :subunit => "Centime",       :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :yer => { :priority => 100, :iso_code => "YER", :name => "Yemeni Rial",                               :symbol => "﷼",             :subunit => "Fils",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :zar => { :priority => 100, :iso_code => "ZAR", :name => "South African Rand",                        :symbol => "R",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :zmk => { :priority => 100, :iso_code => "ZMK", :name => "Zambian Kwacha",                            :symbol => "ZK",            :subunit => "Ngwee",         :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },
      :zwd => { :priority => 100, :iso_code => "ZWD", :name => "Zimbabwean Dollar",                         :symbol => "$",             :subunit => "Cent",          :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },

      # aliases for BC with documentation before Currency
      :yen => { :priority => 100, :iso_code => "JPY", :name => "Japanese Yen",                              :symbol => "¥",             :subunit => "Sen",           :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" },

      # kept for backwards compatibility, real entry is :ghs
      :ghc => { :priority => 100, :iso_code => "GHS", :name => "Ghanaian Cedi",                             :symbol => "₵",             :subunit => "Pesewa",        :subunit_to_unit => 100,   :separator => ".", :delimiter => ",", :format => "%u%n" }
    }

    # The symbol used to identify the currency, usually the lowercase
    # +iso_code+ attribute.
    #
    # @return [Symbol]
    attr_reader :id

    # A numerical value you can use to sort/group the currency list.
    #
    # @return [Integer]
    attr_reader :priority

    # The international 3-letter code as defined by the ISO 4217 standard.
    #
    # @return [String]
    attr_reader :iso_code

    # The currency name.
    #
    # @return [String]
    attr_reader :name

    # The currency symbol (UTF-8 encoded).
    #
    # @return [String]
    attr_reader :symbol

    # The name of the fractional monetary unit.
    #
    # @return [String]
    attr_reader :subunit

    # The proportion between the unit and the subunit
    #
    # @return [Integer]
    attr_reader :subunit_to_unit

    # The character used to separate the whole unit from the subunit.
    #
    # @return [String]
    attr_reader :separator

    # The character used to separate thousands grouping of the whole unit.
    #
    # @return [String]
    attr_reader :delimiter

    # Format conventially used to display given currency.
    #
    # @return [String]
    attr_reader :format

    # The number of decimal places needed.
    #
    # @return [Integer]
    def decimal_places
      if subunit_to_unit == 1
        0
      elsif subunit_to_unit % 10 == 0
        Math.log10(subunit_to_unit).to_s.to_i
      else
        Math.log10(subunit_to_unit).to_s.to_i+1
      end
    end

    # Create a new +Currency+ object.
    #
    # @param [String, Symbol, #to_s] id Used to look into +TABLE+ and retrieve
    #  the applicable attributes.
    #
    # @return [Money::Currency]
    #
    # @example
    #   Money::Currency.new(:usd) #=> #<Money::Currency id: usd ...>
    def initialize(id)
      @id  = id.to_s.downcase.to_sym
      data = TABLE[@id] || raise(UnknownCurrency, "Unknown currency `#{id}'")
      ATTRIBUTES.each do |attribute|
        instance_variable_set(:"@#{attribute}", data[attribute])
      end
    end

    # Compares +self+ with +other_currency+ against the value of +priority+
    # attribute.
    #
    # @param [Money::Currency] other_currency The currency to compare to.
    #
    # @return [-1,0,1] -1 if less than, 0 is equal to, 1 if greater than
    #
    # @example
    #   c1 = Money::Currency.new(:usd)
    #   c2 = Money::Currency.new(:jpy)
    #   c1 <=> c2 #=> 1
    #   c2 <=> c1 #=> -1
    #   c1 <=> c1 #=> 0
    def <=>(other_currency)
      self.priority <=> other_currency.priority
    end

    # Compares +self+ with +other_currency+ and returns +true+ if the are the
    # same or if their +id+ attributes match.
    #
    # @param [Money::Currency] other_currency The currency to compare to.
    #
    # @return [Boolean]
    #
    # @example
    #   c1 = Money::Currency.new(:usd)
    #   c2 = Money::Currency.new(:jpy)
    #   c1 == c1 #=> true
    #   c1 == c2 #=> false
    def ==(other_currency)
      self.equal?(other_currency) ||
      self.id == other_currency.id
    end

    # Compares +self+ with +other_currency+ and returns +true+ if the are the
    # same or if their +id+ attributes match.
    #
    # @param [Money::Currency] other_currency The currency to compare to.
    #
    # @return [Boolean]
    #
    # @example
    #   c1 = Money::Currency.new(:usd)
    #   c2 = Money::Currency.new(:jpy)
    #   c1.eql? c1 #=> true
    #   c1.eql? c2 #=> false
    def eql?(other_currency)
      self == other_currency
    end

    # Returns a Fixnum hash value based on the +id+ attribute in order to use
    # functions like & (intersection), group_by, etc.
    #
    # @return [Fixnum]
    #
    # @example
    #   Money::Currency.new(:usd).hash #=> 428936
    def hash
      id.hash
    end

    # Returns a string representation corresponding to the upcase +id+
    # attribute.
    #
    # -–
    # DEV: id.to_s.upcase corresponds to iso_code but don't use ISO_CODE for consistency.
    #
    # @return [String]
    #
    # @example
    #   Money::Currency.new(:usd).to_s #=> "USD"
    #   Money::Currency.new(:eur).to_s #=> "EUR"
    def to_s
      id.to_s.upcase
    end

    # Returns a human readable representation.
    #
    # @return [String]
    #
    # @example
    #   Money::Currency.new(:usd) #=> #<Currency id: usd ...>
    def inspect
      "#<#{self.class.name} id: #{id} #{ATTRIBUTES.map { |a| "#{a}: #{send(a)}" }.join(", ")}>"
    end

    # Class Methods
    class << self

      # Lookup a currency with given +id+ an returns a +Currency+ instance on
      # success, +nil+ otherwise.
      #
      # @param [String, Symbol, #to_s] id Used to look into +TABLE+ and
      # retrieve the applicable attributes.
      #
      # @return [Money::Currency]
      #
      # @example
      #   Money::Currency.find(:eur) #=> #<Money::Currency id: eur ...>
      #   Money::Currency.find(:foo) #=> nil
      def find(id)
        id = id.to_s.downcase.to_sym
        if data = self::TABLE[id]
          new(id)
        end
      end

      # Wraps the object in a +Currency+ unless it's already a +Currency+
      # object.
      #
      # @param [Object] object The object to attempt and wrap as a +Currency+
      # object.
      #
      # @return [Money::Currency]
      #
      # @example
      #   c1 = Money::Currency.new(:usd)
      #   Money::Currency.wrap(nil)   #=> nil
      #   Money::Currency.wrap(c1)    #=> #<Money::Currency id: usd ...>
      #   Money::Currency.wrap("usd") #=> #<Money::Currency id: usd ...>
      def wrap(object)
        if object.nil?
          nil
        elsif object.is_a?(Currency)
          object
        else
          Currency.new(object)
        end
      end
    end
  end
end
