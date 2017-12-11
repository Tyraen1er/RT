/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   rand.cl                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bmoiroud <bmoiroud@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2017/11/02 15:33:59 by bmoiroud          #+#    #+#             */
/*   Updated: 2017/11/02 15:33:59 by bmoiroud         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "rt.h.cl"

static unsigned int		ft_rand(const int x)
{
	unsigned int value = x;

	value = (value ^ 61) ^ (value>>16);
	value *= 9;
	value ^= value << 4;
	value *= 0x27d4eb2d;
	value ^= value >> 15;
	return (value);
}

static unsigned int		ft_rand2(const int x, const int y)
{
	unsigned int value = ft_rand(x);

	return (ft_rand(value ^ y));
}

static unsigned int		ft_rand3(const int x, const int y, const int z)
{
	unsigned int value = ft_rand(x);

	value = ft_rand(value ^ y);
	return (ft_rand(value ^ z));
}