package io.github.dev_connor.security;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Log4j
@Component("customPasswordEncoder")
public class CustomNoOpPasswordEncoder implements PasswordEncoder {
	public String encode(CharSequence rawPassword) {
		log.warn("before encode :" + rawPassword);
		return rawPassword.toString();
	}

	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		log.warn("matches: " + rawPassword + ":" + encodedPassword);
		return rawPassword.toString().equals(encodedPassword);
	}
}
