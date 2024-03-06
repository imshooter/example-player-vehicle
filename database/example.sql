CREATE TABLE `users` (
    `id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(24) NOT NULL
);

CREATE TABLE `owned-vehicles` (
    `id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `user-id` INT UNSIGNED NOT NULL,
    `model` SMALLINT UNSIGNED NOT NULL,
    `colour-1` INT NOT NULL,
    `colour-2` INT NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `a` FLOAT NOT NULL,
    CONSTRAINT `fk-owned-vehicles-users` FOREIGN KEY (`user-id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `vehicle-components` (
    `vehicle-id` INT UNSIGNED NOT NULL,
    `component-id` INT UNSIGNED NOT NULL,
    UNIQUE KEY `uk-vehicle-id-component-id` (`vehicle-id`, `component-id`),
    CONSTRAINT `fk-vehicle-components-owned-vehicles` FOREIGN KEY (`vehicle-id`) REFERENCES `owned-vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);
