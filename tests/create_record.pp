ora_record{'ARGOS_ABONNEMENT':
  ensure     => 'updated',
  table_name => 'ABONNEMENT',
  username   => 'APP',
  password   => 'APP',
  key_name   => 'ABONNEMENTID',
  key_value  => '19',
  data       => {
      'AFNEMER'                     => 'ARGOS',
      'REISINFORMATIEPRODUCT'       => 'ARGOS',
      'LOCATIELANDELIJKINDICATOR'   => 'J',
      'LOCATIENIETINSTAPPEN'        => 0,
      'STATUS'                      => 0,
      'TIJDVENSTER'                 => 70,
      'LAATSTEVERWERKINGSTIJDSTIP'  => upcase(strftime('%d-%b-%y 12.00.00.000000 PM')),
      'AANMELDTIJDSTIP'             => upcase(strftime('%d-%b-%y 12.00.00.000000 PM')),
      'VERSTUURDEBERICHTEN'         => 0,
      'QUEUENAAM'                   => 'cris.pub2.jms.queue.output',
    }
}
