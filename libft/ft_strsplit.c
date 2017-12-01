/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strsplit.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2016/11/08 18:40:40 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/09/14 14:04:36 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"
#include <stdlib.h>

char			**ft_strsplit(char const *str, char c)
{
	size_t	len;
	int		i;
	char	**tab;

	len = 0;
	i = 0;
	if (str == NULL)
		return (NULL);
	if ((tab = (char **)malloc(sizeof(char *) * (ft_countwords(str, c) + 1))))
	{
		while (*str)
		{
			while (*str == c)
				str++;
			if (*str)
			{
				len = ft_getword(str, c);
				tab[i++] = ft_strsub(str, 0, len);
				str += len;
			}
		}
		tab[i] = NULL;
		return (tab);
	}
	return (NULL);
}

// static	char	*ft_countstr(const char *s, char c, int g, int *n)
// {
// 	char	*str;
// 	int		t;
// 	int		i;
//
// 	i = 0;
// 	while (s[*n] == c)
// 		++*n;
// 	t = *n;
// 	while (s[*n] != c && s[*n] != '\0')
// 	{
// 		++*n;
// 		g++;
// 	}
// 	if (!(str = (char *)malloc(sizeof(char) * (g + 1))))
// 		return (NULL);
// 	str[g] = '\0';
// 	while (i < g)
// 	{
// 		str[i] = s[t + i];
// 		i++;
// 	}
// 	return (str);
// }
//
// char			**ft_strsplit(const char *s, char c)
// {
// 	int		i;
// 	int		z;
// 	char	**tab;
//
// 	z = 0;
// 	i = 0;
// 	if (!(tab = ((char **)malloc(sizeof(char *) * (ft_countwords(s, c) + 1)))))
// 		return (NULL);
// 	while (i < ft_countwords(s, c))
// 	{
// 		tab[i] = ft_countstr(s, c, 0, &z);
// 		i++;
// 	}
// 	tab[i] = NULL;
// 	return (tab);
// }
