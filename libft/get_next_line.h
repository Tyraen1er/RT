/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.h                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/01/04 13:57:04 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/04/27 16:04:50 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GET_NEXT_LINE_H
# define GET_NEXT_LINE_H

# define BUFF_SIZE 1

# include <stdlib.h>
# include <unistd.h>
# include <fcntl.h>

int				get_next_line(int const fd, char **line);
size_t			ft_strlen(const char *str);
char			*ft_strjoin(char const *s1, char const *s2);
char			*ft_strnew(size_t size);
char			*ft_strdup(const char *s1);
char			*ft_strchr(const char *s, int c);

#endif
