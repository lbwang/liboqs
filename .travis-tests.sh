#!/bin/bash
: '
Below is an example of the the logic how enable disable macros are implemented
in the code. Use it as a guide to enable disable macros below

void OQS_AES128_free_schedule(void *schedule) {
#ifdef USE_OPENSSL
	oqs_aes128_free_schedule_ossl(schedule);
#else
#ifndef AES_DISABLE_NI
	oqs_aes128_free_schedule_ni(schedule);
#else
	oqs_aes128_free_schedule_c(schedule);
#endif
#endif
}
'

autoreconf -i
enable_disable_str=
if [[ ${USE_OPENSSL} == 1 ]];then
  enable_disable_str="--enable-openssl"
fi

if [[ ${AES_NI} == 0 ]];then
  enable_disable_str=${enable_disable_str}" --disable-aes-ni"
fi


./configure ${enable_disable_str}; make clean; make; make test

bash .travis-style-check.sh
bash .travis-global-namespace-check.sh
bash .travis-banned-functions-check.sh
bash .travis-character-encoding-check.sh