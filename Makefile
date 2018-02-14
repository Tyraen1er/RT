# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2017/02/18 18:32:53 by bmoiroud          #+#    #+#              #
#    Updated: 2017/12/07 14:03:05 by bmoiroud         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = rt

SRCDIR = srcs/c

SRC_NAME = cl.c \
		   ft_check.c \
		   ft_errors.c \
		   ft_get_data.c \
		   ft_get_objects.c \
		   ft_init.c \
		   ft_move.c \
		   ft_parse.c \
		   ft_vector.c \
		   ft_help.c \
		   main.c \
		   sdl_event.c \
		   sdl.c

SRC = $(addprefix $(SRCDIR)/, $(SRC_NAME))

OBJDIR = objs

OBJ = $(addprefix $(OBJDIR)/, $(SRC_NAME:.c=.o))

CFLAGS = -Wall -Werror -Wextra

SDL = -I Frameworks/SDL2.framework/Headers/\
	  -I Frameworks/SDL2_ttf.framework/Headers/\
	  -I Frameworks/SDL2_image.framework/Headers/\

LIB = -Llibft/ -lft

INCLUDES = -I./includes/ -I./libft/ $(SDL)

FRAMEWORKS = -framework OpenCL -rpath @loader_path/Frameworks \
			 -framework SDL2 -framework SDL2_ttf -framework SDL2_image -F ./Frameworks

all:$(NAME)

$(NAME): $(OBJ)
		@make -C libft/
		@echo "\033[0;34m--------------------------------"
		@gcc $(CFLAGS) $(OBJ) $(INCLUDES) $(LIB) $(FRAMEWORKS) -o $@ 
		@echo "\033[0;31m[✓] Linked C executable" $(NAME)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
		@/bin/mkdir -p $(OBJDIR)
		@gcc $(CFLAGS) -c $< -o $@ $(INCLUDES)
		@echo "\033[0;32m[✓] Built C object" $@

clean:
		@make -C libft/ clean
		@/bin/rm -Rf $(OBJDIR)
		@echo "\033[0;33m[✓] Removed object directory" $(OBJDIR)

fclean: clean
		@make -C libft/ fclean
		@/bin/rm -f $(NAME)
		@echo "\033[0;33m[✓] Removed executable" $(NAME)

re: fclean all

.PHONY: all clean fclean re
