
import 'package:virtual_officine/env.dart';

String? urlpvt = Environment.hostUrlPvt;

String? urlsti = Environment.hostUrlSti;

String? reazon = 'v1';

String? reazonAffiliate = 'affiliate';

String? reazonQr = 'global';

//PRIVACY POLICY
String serviceGetPrivacyPolicy() =>
    'https://www.muserpol.gob.bo/index.php/transparencia/terminos-y-condiciones-de-uso-aplicacion-movil';
//CONTACTS
String serviceGetContacts() => '$urlsti/app/contacts';

//AUTH
String serviceAuthSession(int? affiliateId) => '$urlpvt/$reazon/auth/$affiliateId';

//////////////////////////////////////////////////
/////////////OFICINA VIRTUAL/////////////////////
////////////////////////////////////////////////
// QR
String serviceGetQr(String info) => '$urlsti/$reazonQr/procedure_qr/$info';
// AUTH
String serviceAuthSessionOF() => '$urlsti/$reazonAffiliate/auth';
// CHANGE PASSWORD
String serviceChangePasswordOF() => '$urlsti/$reazonAffiliate/change_password';
// FORGOT PASSWORD
String serviceForgotPasswordOF() => '$urlsti/app/send_code_reset_password';
// FORGOT PASSWORD SEND CODE
String serviceSendCodeOF() => '$urlsti/app/reset_password';
//////////////////////////////////////////////////
/////////////APORTES/////////////////////
////////////////////////////////////////////////

// APORTES
String serviceContributions(int affiliateId) => '$urlsti/app/all_contributions/$affiliateId';
//PRINT APORTES PASIVO
String servicePrintContributionPasive(int affiliateId) => '$urlsti/app/contributions_passive/$affiliateId';
//PRINT APORTES ACTIVO
String servicePrintContributionActive(int affiliateId) => '$urlsti/app/contributions_active/$affiliateId';

//////////////////////////////////////////////////
/////////////PRSTAMOS/////////////////////
////////////////////////////////////////////////

//PRESTAMOS
String serviceLoans(int affiliateId) => '$urlsti/app/get_information_loan/$affiliateId';
//PRINT PLAN DE PAGOS
String servicePrintLoans(int loanId) => '$urlsti/app/loan/$loanId/print/plan';
//PRINT KARDEX
String servicePrintKadex(int loanId) => '$urlsti/app/loan/$loanId/print/kardex';
