# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2017/02/18 18:32:53 by bmoiroud          #+#    #+#              #
#    Updated: 2017/10/18 17:47:34 by bmoiroud         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = rt

SRCDIR = srcs/c

SRC_NAME = cl.c \
		   ft_check.c \
		   ft_errors.c \
		   ft_get_data.c \
		   ft_init.c \
		   ft_move.c \
		   ft_parse.c \
		   ft_vector.c \
		   main.c \
		   sdl_event.c \
		   sdl.c

SRC = $(addprefix ${SRCDIR}/, ${SRC_NAME})

OBJDIR = objs

OBJ = $(addprefix ${OBJDIR}/, $(SRC_NAME:.c=.o))

CC = gcc

CFLAGS = -Wall -Werror -Wextra

SDL = -I Frameworks/SDL2.framework/Headers/\
	  -I Frameworks/SDL2_ttf.framework/Headers/\
	  -I Frameworks/SDL2_image.framework/Headers/\

LIB = -Llibft/ -lft

INCLUDES = -I./includes/ -I./libft/ $(SDL)

FRAMEWORKS = -framework OpenCL -rpath @loader_path/Frameworks \
			 -framework SDL2 -framework SDL2_ttf -framework SDL2_image -F ./Frameworks

all:${NAME}

${NAME}: ${OBJ}
		@make -C libft/
		@${CC} ${CFLAGS} ${INCLUDES} ${LIB} ${FRAMEWORKS} -o $@ $^

${OBJDIR}/%.o: ${SRCDIR}/%.c
		@/bin/mkdir -p ${OBJDIR}
		@${CC} ${CFLAGS} ${INCLUDES} -c -o $@ $<

clean:
		@make -C libft/ clean
		@/bin/rm -Rf ${OBJDIR}

fclean: clean
		@make -C libft/ fclean
		@/bin/rm -f ${NAME}

re: fclean all

.PHONY: all clean fclean re
