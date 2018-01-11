/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_countwords.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/23 13:39:47 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/12/02 16:19:55 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

// int		ft_countwords(const char *str, char c)
// {
// 	int nb;

// 	nb = 0;
// 	while (*str && ++nb)
// 	{
// 		while (*str == c)
// 			str++;
// 		if (!*str)
// 			return (nb);
// 		else
// 			str++;
// 	}
// 	return (nb);
// }

int				ft_countwords(const char *str, char c)
{
	size_t	i;
	int		w;

	i = 0;
	w = 0;
	while (str[i])
	{
		while (str[i] == c)
			i++;
		if (i < ft_strlen(str))
			w++;
		while (str[i] != c && str[i] != '\0')
			i++;
	}
	return (w);
}
